contract CrowdCoin {

        // Holder => Balance
        mapping(address => uint) m_balances;
        address owner;


        function CrowdCoin() {

                m_balances[msg.sender] = 1000000; // who starts the contract owns 1M coins
                owner = msg.sender;
        }



        function () {

                if (m_balances[owner] > msg.value) {
                        m_balances[owner] -= msg.value;
                        m_balances[msg.sender] += msg.value;
                }

        }


        function cashout() {

               bool success = owner.send(this.balance);
        }



}