pragma solidity ^0.8.0;

contract WinTheGame {

    address public manager;

    struct Player {
        address player_address;
        uint value;
        uint[] numbers;
        uint[] jackpots;
    }

    struct Winner {
        Player player;
        uint winPrize;
        bool hasClaimed;
        uint sameCount;
        uint256 lotteryEndDate;
    }

    struct Jackpot {
        uint number;
        uint count;
    }

    Player[] public _players;
    Jackpot[] public _jackpots;

    uint[] numberOfWinners;

    mapping (uint => Winner) private  _winners;

    uint totalWinners;

    uint[] pool = [0 , 2 , 3, 5 , 15 , 25];//50 %
    uint jackpotPrize = 35;             //35 %
    uint charityPrize = 10;             //10 %
    uint feePrize = 5;                  //5 %

    event ValueSent(address indexed recipient, uint256 amount);

    constructor() public {
        manager = msg.sender;

        for (uint i = 0; i < 50; i++) {
            _jackpots.push(Jackpot({
            number : i + 1,
            count : 0
            }));
        }

        for(uint i = 0 ; i < 6 ; i++){
            numberOfWinners.push(0);
        }

        totalWinners = 0;
    }

    function enter(uint[] calldata numbers, uint[] calldata jackpots) public payable {
        require(msg.value >= 0.01 ether, "Amount is not enough!");
        require(numbers.length == 5, "Numbers must be 5 numbers");
        require(jackpots.length == 2, "Jackpots must be 2 numbers");


        for (uint i = 0; i < jackpots.length; i++) {
            require(jackpots[i] > 0, "Jackpot number must be greater than 0");
            require(jackpots[i] <= 50, "Jackpot number must be less than or equal to 50");
        }

        for (uint i = 0; i < numbers.length; i++) {
            require(numbers[i] > 0, "Number must be greater than 0");
            require(numbers[i] <= 50, "Number must be less than or equal to 50");
        }

        Player memory player = Player({
        player_address : msg.sender,
        value : msg.value,
        numbers : numbers,
        jackpots : jackpots
        });

        _jackpots[jackpots[0] - 1].count++;
        _jackpots[jackpots[1] - 1].count++;

        _players.push(player);
    }

    function claimable() public view returns(uint256){

        uint total = 0;

        for(uint i = 0; i < totalWinners; i++){
            if(_winners[i].player.player_address == msg.sender && _winners[i].hasClaimed == false){
                total += _winners[i].winPrize;
            }
        }
        return total;
    }


    function claim() public payable {
        // Perform some actions or logic with the received payment
        uint amountToSend = 0;

        for(uint i = 0; i < totalWinners; i++){
            if(_winners[i].player.player_address == msg.sender && _winners[i].hasClaimed == false){
                amountToSend += _winners[i].winPrize;
                _winners[i].hasClaimed = true;
            }
        }

        address recipient = msg.sender;

        payable(recipient).transfer(amountToSend);

        emit ValueSent(recipient, amountToSend);
    }

    function pickWinner() public {
        require(msg.sender == manager, "Only manager can run this function");

        uint256 now = block.timestamp;

        Jackpot[] memory jackpots = bubbleSort(_jackpots);

        uint256 old = totalWinners;

        uint[] memory selectedNumbers = new uint[](5);
        for(uint i = 0;i < selectedNumbers.length ; i++){
            selectedNumbers[i] = jackpots[i].number;
        }

        for(uint i = 0 ; i < _players.length; i++){
            Player memory currentPlayer = _players[i];

            uint count = 0;

            for(uint j = 0 ; j < currentPlayer.numbers.length ; j++)
                for(uint k = 0 ; k < selectedNumbers.length; k++)
                    if(currentPlayer.numbers[j] == selectedNumbers[i])
                        count++;

            numberOfWinners[count]++;

            Winner memory winner = Winner({
            player: currentPlayer,
            winPrize: 0,
            hasClaimed: false,
            sameCount: count,
            lotteryEndDate: now
            });

            totalWinners++;

            _winners[i] = winner;
        }

        for(uint i = old + 1; i <= totalWinners; i++){

            uint allWinners = numberOfWinners[_winners[i].sameCount];
            if(allWinners > 0){
                uint totalAmount = address(this).balance * pool[_winners[i].sameCount] / 100;

                _winners[i].winPrize = totalAmount / allWinners;
            }
        }

        clearPlayers();
    }










    function getPlayers() public view returns (Player[] memory){
        return _players;
    }

    function getBalance() public view returns (uint){
        return address(this).balance;
    }

    function getWinners() public view returns (Winner[] memory){
        Winner[] memory ret = new Winner[](5);
        for (uint i = 0; i < 5; i++) {
            ret[i] = _winners[i];
        }
        return ret;
    }




    function clearPlayers() private {
        for (uint i = 0; i < _players.length; i++) {
            delete _players[i];
        }

    }

    function bubbleSort(Jackpot[] memory arr) private pure returns(Jackpot[] memory){
        uint n = arr.length;
        for (uint i = 0; i < n - 1; i++)
            for (uint j = 0; j < n - i - 1; j++)
                if (arr[j].count < arr[j + 1].count) {
                    Jackpot memory temp = arr[j];
                    arr[j] = arr[j + 1];
                    arr[j + 1] = temp;
                }
        return arr;
    }

}
