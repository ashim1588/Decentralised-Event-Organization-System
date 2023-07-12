//SPDX-License-Identifier: Unilicense
pragma solidity >= 0.5.0 < 0.9.0;

 contract EventContract {
     struct Event{
         address organizer;
         string name;
         uint date;
         uint price;
         uint ticketCount;
         uint ticketRemaining;
     }

mapping(uint=>Event) public events;
mapping(address=>mapping(uint=>uint)) public tickets;
uint public nextId;

function createEvent(string memory name,uint date, uint price, uint ticketCount) external {
    require(date>block.timestamp, "You can organize event for future date");
    require(ticketCount>0, "You can organize event only if you create more than 0 tickets");
    events[nextId] = Event(msg.sender,name,date,price,ticketCount,ticketCount);
    nextId++;
}

function buyTicket(uint id,uint quantity) external payable{
    require(events[id].date!=0, "This event does not exist!");
    require(block.timestamp<events[id].date, "Event has already occurred.");
    Event storage _event = events[id];
    require(msg.value==(_event.price*quantity), "Ether is not enough.");
    require(_event.ticketRemaining>=0, "The event is already full!");
    _event.ticketRemaining-=quantity;
    tickets[msg.sender][id]+=quantity; 
}

function transferTicket(uint id, uint quantity, address to) external {
    require(events[id].date!=0, "This event does not exist!");
    require(block.timestamp<events[id].date, "Event has already occurred.");
    require(tickets[msg.sender][id]>=quantity, "You don't have enough tickets!");
    tickets[msg.sender][id]-=quantity;
    tickets[to][id]+=quantity;
}
 }