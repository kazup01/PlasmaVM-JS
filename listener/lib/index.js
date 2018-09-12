const Web3 = require('web3');
const web3 = new Web3(new Web3.providers.HttpProvider(process.env.ROOTCHAIN_ENDPOINT));
const RootChainAbi = require('../assets/RootChain.json').abi;

const rootChain = new web3.eth.Contract(RootChainAbi, process.env.ROOTCHAIN_ADDRESS);

module.exports.run = childChain => {
  rootChain.events.Deposit((e) => {
    console.log(e);
  })

  childChain.events.TxAdded((e) => {
    if (e.type == "deposit") {
      childChain.commitmentTxs.push(tx);
      childChain.generateBlock();
    } else if (e.type == "basic") {
      // check gaslimit of block and generate block
      // Ideally this must be called before Tx added, otherwise big Tx will be inserted to block
      let gasOfTxs = childChain.getLatestBlock().commitmentTxs.reduce((acm, tx)=>{
        return acm + tx1.gasused
      }, 0)
      if (gasOfTxs > childChain.getLatestBlock().gasLimit) {
        childChain.generateBlock()
      }
    }
  })
  childChain.events.BlockGenerated((e) => {
    if (type == "basic") {

      // Make snapshot and 
      this.commitmentTxs
        .filter((tx) => !!this.snapshot.applyTx(tx) )
        .forEach((tx) => newBlock.appendTx(tx) );

      this.blocks.push(newBlock);
      // submitRoothash()
    }
  })
  rootChain.events.RoothashSubmitted((e) => {
    console.log(e);
  })

}
