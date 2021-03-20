   // Solidity code Faucet8.sol from Pg. 150 Mastering Ethereum
   // Modified for 5.0 and with comments.
   pragma solidity ^0.5.0;

   contract owned {
      address payable owner;
      // This constructor will be inherited.
      // It takes no arguments and so the
      // migration will be simple.
      constructor() public {
        owner = msg.sender;
      }
      // A modifier is a precondition. If the precondition is not satisfied then
      // the transaction will revert to its prior state.
      modifier onlyOwner {
        require (msg.sender == owner, "Only the creator of this contract may call this function");
        _;
      }
   }
   // Mortal inherits all features of the contract owned.
   // Mortals may die.
   contract mortal is owned {
     // only the creator may destroy this contract
     function destroy() public onlyOwner {
       selfdestruct(address(uint160(owner)));
     }
   }
   // Single inheritance
   contract Faucet is mortal {
       // Events end up in the receipt of the transaction.
       // The events may be examined by the contracts caller.

       event Withdrawal(address indexed to, uint amount);
       event Deposit(address indexed from, uint amount);

       // Withdraw by anyone as long as it's not greater
       // than 0.1 ether and as long as the contract has ether
       // to spare.
       function withdraw(uint withdraw_amount) public {
           require(withdraw_amount <= 0.1 ether);
           require((address(this)).balance >= withdraw_amount,"Balance too small for this withdrawal");
           msg.sender.transfer(withdraw_amount);
           emit Withdrawal(msg.sender, withdraw_amount);
       }
       // Pay ether to the contract. Generate an event
       // upon deposit.
       function() external payable {
         emit Deposit(msg.sender, msg.value);
       }
   }
