// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

    /*
        The EventTickets contract keeps track of the details and ticket sales of one event.
     */

contract EventTickets {

    /*
        Create a public state variable called owner.
        Use the appropriate keyword to create an associated getter function.
        Use the appropriate keyword to allow ether transfers.
     */
    address payable owner;
    uint   TICKET_PRICE = 100 wei;

    /*
        Create a struct called "Event".
        The struct has 6 fields: description, website (URL), totalTickets, sales, buyers, and isOpen.
        Choose the appropriate variable type for each field.
        The "buyers" field should keep track of addresses and how many tickets each buyer purchases.
    */
    struct Event{
        string description;
        string url;
        uint256 totalTickets;
        uint256 sales;
        mapping(address=>uint256) buyers;
        bool isOpen;
    }
   Event myEvent;
    /*
        Define 3 logging events.
        LogBuyTickets should provide information about the purchaser and the number of tickets purchased.
        LogGetRefund should provide information about the refund requester and the number of tickets refunded.
        LogEndSale should provide infromation about the contract owner and the balance transferred to them.
    */
    event LogBuyTickets(address purchaser, uint256 numOfTickets);
    event LogGetRefund(address requester, uint256 numOfRefundedTickets);
    event LogEndSale(address cotractOwner, uint256 balanceTransfered);
    

    /*
        Create a modifier that throws an error if the msg.sender is not the owner.
    */
    modifier isOwner {
        require(msg.sender==owner,"Not Owner");_;
    }
    

    /*
        Define a constructor.
        The constructor takes 3 arguments, the description, the URL and the number of tickets for sale.
        Set the owner to the creator of the contract.
        Set the appropriate myEvent details.
    */
    constructor (string memory description,string memory url,uint256 sales){
        owner=payable(msg.sender);
        myEvent.description=description;
        myEvent.url=url;
        myEvent.sales=sales;
        myEvent.isOpen=true;
    }
    /*
        Define a function called readEvent() that returns the event details.
        This function does not modify state, add the appropriate keyword.
        The returned details should be called description, website, uint totalTickets, uint sales, bool isOpen in that order.
    */
    function readEvent()
        public
        view
        returns(string memory , string memory , uint , uint , bool)
    {
        return(myEvent.description, myEvent.url,  myEvent.totalTickets,  myEvent.sales, myEvent.isOpen);
    }

    /*
        Define a function called getBuyerTicketCount().
        This function takes 1 argument, an address and
        returns the number of tickets that address has purchased.
    */
    function getBuyerTicketCount(address buyer) public view returns(uint256){
        return myEvent.buyers[buyer];
    }
    /*
        Define a function called buyTickets().
        This function allows someone to purchase tickets for the event.
        This function takes one argument, the number of tickets to be purchased.
        This function can accept Ether.
        Be sure to check:
            - That the event isOpen
            - That the transaction value is sufficient for the number of tickets purchased
            - That there are enough tickets in stock
        Then:
            - add the appropriate number of tickets to the purchasers count
            - account for the purchase in the remaining number of available tickets
            - refund any surplus value sent with the transaction
            - emit the appropriate event
    */
    function buyTickets(uint256 numOfTickets) public payable {
        require(myEvent.isOpen,"not Open");
        uint256 totalCost=numOfTickets*TICKET_PRICE;
        require(msg.value>=totalCost,"Insufficient Funds");
        uint256 stock=myEvent.totalTickets-myEvent.sales;
        require(stock>1,"HouseFull, No more tickets");

        myEvent.buyers[msg.sender] += numOfTickets;
        myEvent.sales += numOfTickets;

        if (msg.value > totalCost){
            uint256 refundAmt=msg.value-totalCost;
            payable(msg.sender).transfer(refundAmt);
        }

        emit LogBuyTickets (msg.sender,numOfTickets);

    }
    /*
        Define a function called getRefund().
        This function allows someone to get a refund for tickets for the account they purchased from.
        TODO:
            - Check that the requester has purchased tickets.
            - Make sure the refunded tickets go back into the pool of avialable tickets.
            - Transfer the appropriate amount to the refund requester.
            - Emit the appropriate event.
    */
    function getRefund() public payable {
        uint256 numOfTickets = myEvent.buyers[msg.sender];
        require (numOfTickets>0,"No Tickets");

        uint256 refundAmt= numOfTickets*TICKET_PRICE;
        payable(msg.sender).transfer(refundAmt);

        myEvent.sales -= numOfTickets;

        emit LogGetRefund(msg.sender,numOfTickets);
    }
    /*
        Define a function called endSale().
        This function will close the ticket sales.
        This function can only be called by the contract owner.
        TODO:
            - close the event
            - transfer the contract balance to the owner
            - emit the appropriate event
    */

    function endSale() public payable {
        myEvent.isOpen=false;
        owner.transfer(myEvent.sales*TICKET_PRICE);

        emit LogEndSale(owner,myEvent.sales*TICKET_PRICE);
    }
}