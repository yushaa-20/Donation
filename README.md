I started the project by creating the donation.sol  file, which I created the donation contract inside it.
import "./PriceConverter.sol";  this line of code imports a library or contract named `PriceConverter`, which is used to convert values from Ether to USD.
“using PriceConverter  for uint256” code  allows the use of functions from the `PriceConverter` library on `uint256` data type.
“address public owner” codes allows the address of the contract owner to be  set when the contract is deployed.
“uint256 public constant MINIMUM_USD = 50 * 1e18;” sets  a constant that defines the minimum donation amount in USD  to $50.
“mapping(address => uint256) public donations;” is a code for  mapping that tracks the amount donated by each address.
 “address[] public funders;” creates an array to keep track of all addresses that have donated.


constructor() {
    owner = msg.sender;
}
This constructor sets the `owner` variable to the address that deploys the contract.


function fund() public payable {
    require(msg.value.getConversionRate() >= MINIMUM_USD, "Minimum donation is $50");
    donations[msg.sender] += msg.value;
    funders.push(msg.sender);
    emit donationsReceived(msg.sender, msg.value);
}
The fund() is made payable to allow users to send Ether to the contract.
  It also checks that the donation meets the minimum USD requirement using the `getConversionRate` function from the `PriceConverter` library. The function also updates the `donations` mapping and adds the donor to the `funders` array.

function withdraw() public onlyOwmer {
    uint256 contractBalance = address(this).balance;
    require(contractBalance > 0, "No funds to withdraw");

    (bool success, ) = owner.call{value: contractBalance}("");
    require(success, "Withdrawal failed");

    emit fundsWithdrawn(owner, contractBalance);
}
The withdraw()  allows the owner to withdraw all funds from the contract. It also checks if there are funds available using this line of codes  “(bool success, ) = owner.call{value: contractBalance}("");”.

function getBalance() public view returns(uint256) {
    return address(this).balance;
}
And finally, the getBalance()   function  returns the current balance of the contract after the funds are withdrawn.
library PriceConverter {
```
- **PriceConverter**: This library contains functions for fetching and converting the price of Ether.

#### 4. **Get Price Function**
```solidity
function getPrice() internal view returns (uint256) {
    // ETH/USD price feed on Sepolia Testnet
    AggregatorV3Interface priceFeed = AggregatorV3Interface(
        0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
    );
    (, int256 price, , , ) = priceFeed.latestRoundData();
    return uint256(price * 1e10); // Adjust to 18 decimal places
}
The getPrice()   function retrieves the current ETH/USD price from the price feed. The “Price Feed” Address  of  `0x5B38Da6a701c568545dCfcB03FcB875f56beddC4` corresponds to an ETH/USD price feed on the Sepolia Testnet.

function getConversionRate(uint256  ethAmount) 
    internal 
    view 
    returns (uint256) 
{
    uint256 ethPrice = getPrice(); 
    return (ethPrice * ethAmount) / 1e18;
}
getConversionRate(uint256  ethAmount)”  function converts a given amount of Ether into its equivalent USD value.  And when this `getPrice()`  is called, it gets the current ETH price.
  This line of codes “    return (ethPrice * ethAmount) / 1e18;” calculates the conversion rate by multiplying the ETH price by the amount of Ether and dividing by `1e18` to standardize the value.
