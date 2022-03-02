// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.6.0 <0.9.0;


contract Twitter {

    address payable user;
    uint tweetCount = 0;

    mapping (uint => address) public tweetOwner;

    constructor() public {
        user = msg.sender;
    }

    struct Tweet {
        uint id;
        string tweetText;
        uint tipAmount;
        address payable author;
    }


    Tweet[] public tweets;

    event TweetSended(
        uint id,
        string tweetText,
        uint tipAmount,
        address payable author
    );

    event TweetTipped(
        uint id,
        string Tweet,
        uint tipAmount,
        address payable author
    );


    function Tweeted(string memory tweet) public{
        require(msg.sender!=address(0));
        tweets.push(Tweet(tweetCount, tweet, 0, msg.sender));
        tweetOwner[tweetCount] = msg.sender;
        emit TweetSended(tweetCount, tweet, 0, msg.sender);
        tweetCount++;
    }

    function tipTweet(uint tipAmount, uint _tweetId) public payable{
        require(msg.sender != tweetOwner[_tweetId]);
        Tweet memory _tweet = tweets[_tweetId];
        address payable _author = _tweet.author;
        _author.transfer(tipAmount);
        _tweet.tipAmount = _tweet.tipAmount + tipAmount;
        tweets[_tweetId] = _tweet;
        emit TweetTipped(_tweet.id, _tweet.tweetText, _tweet.tipAmount, _author);
    }


    function getOwner() public view returns(address){
        return user;
    }

}
