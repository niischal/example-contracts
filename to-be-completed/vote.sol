// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;
contract cityPoll {
    
    struct City {
        string cityName;
        uint256 vote;
        //you can add city details if you want
    }


    mapping(uint256 => City) public cities; //mapping city Id with the City ctruct - cityId should be uint256
    mapping(address => bool) hasVoted; //mapping to check if the address/account has voted or not

    address owner;
    uint256 public cityCount = 5; // number of city added
    constructor() {
    //TODO set contract caller as owner
        owner=msg.sender;

    //TODO set some intitial cities.
        cities[0].cityName="Kathmandu";
        cities[1].cityName="Banepa";
        cities[2].cityName="Bhaktapur";
        cities[3].cityName="Lalitpur";
        cities[4].cityName="Dhulikhel";
    }

    function addCity(string memory name) public {
      //  TODO: add city to the CityStruct
        uint256 cityId = cityCount;
        cities[cityId].cityName=name;
        cityCount++;
    }
    
    function vote(uint256 cityId) public {
        //TODO Vote the selected city through cityID
        require(!hasVoted[msg.sender],"Already Voted");
        cities[cityId].vote++;
        hasVoted[msg.sender]=true;
    }
    function getCity(uint256 cityId) public view returns (string memory) {
     // TODO get the city details through cityID
        return cities[cityId].cityName;
    }
    function getVote(uint256 cityId) public view returns (uint256) {
    // TODO get the vote of the city with its ID
         return cities[cityId].vote;
    }
}