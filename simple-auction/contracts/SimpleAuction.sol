// 0x211b1b6e61e475ace9bf13ae79373ddb419b5f72
// 0xbebebebebebebebebebebebebebebebebebebebe

contract SimpleAuction {
        // Parameters of the auction. Times are either
        // absolute unix timestamps (seconds since 1970-01-01)
        // ore time periods in seconds.
        address public beneficiary;


        // Current state of the auction.
        address public highestBidder;
        uint public highestBid;

        string public subject = "Lamburgini Centenario 2016";

        // Set to true at the end, disallows any change
        bool ended;

        // Events that will be fired on changes.
        event HighestBidIncreased(address bidder, uint amount);
        event AuctionEnded(address winner, uint amount);

        // The following is a so-called natspec comment,
        // recognizable by the three slashes.
        // It will be shown when the user is asked to
        // confirm a transaction.

        /// Create a simple auction with `_biddingTime`
        /// seconds bidding time on behalf of the
        /// beneficiary address `_beneficiary`.
        function SimpleAuction(address _beneficiary) {
                beneficiary = _beneficiary;
        }

        /// Bid on the auction with the value sent
        /// together with this transaction.
        /// The value will only be refunded if the
        /// auction is not won.
        function bid() {

                
                if (msg.value <= highestBid)
                // If the bid is not higher, send the
                // money back.
                        throw;

                bool success;

                if (highestBidder != 0)
                        success = highestBidder.send(highestBid);

                highestBidder = msg.sender;
                highestBid = msg.value;
                HighestBidIncreased(msg.sender, msg.value);
        }

        /// End the auction and send the highest bid
        /// to the beneficiary.
        function auctionEnd() {

                AuctionEnded(highestBidder, highestBid);
                // We send all the money we have, because some
                // of the refunds might have failed.
                log1("send: ", bytes32(this.balance));
                bool success = beneficiary.send(this.balance);

                ended = true;
        }

        function() {
                // This function gets executed if a
                // transaction with invalid data is sent to
                // the contract or just ether without data.
                // We revert the send so that no-one
                // accidentally loses money when using the
                // contract.
                throw;
        }
}