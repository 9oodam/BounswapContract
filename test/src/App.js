import './App.css';
import {useState, useEffect} from 'react';

import Web3 from 'web3';
import testAbi from './abi/Test.json';

const App = () => {
  const [user, setUser] = useState(null);
  const [web3, setWeb3] = useState(null);
  const [testContract, setContract] = useState(null);
  const [functionInfo, setFunctionInfo] = useState([]);

  useEffect(() => {
    if(window.ethereum) {
        window.ethereum.request({method : "eth_requestAccounts"}).then(async ([data]) => {
            const web3Provider = new Web3(window.ethereum);

            setUser({
                account : data,
                balance : web3Provider.utils.toWei(await web3Provider.eth.getBalance(data), "ether")
            });
            setWeb3(web3Provider);
        })
    }else {
        alert("메타마스크 연결 요망")
    }
  }, []);

  useEffect(() => {
    if(web3 !== null) {
      if(testContract) return;
      const contract = new web3.eth.Contract(testAbi, '0x6a20e510A6dEa615622DD3B768F9Dd4c8c8484b9', {data : ""});
      setContract(contract);

      // const info = [
      //   {
      //     name : 'test2PlayFirst',
      //     args : ["Hello, World!"]
      //   },
      //   {
      //     name : 'test2PlaySecond',
      //     args : [12345]
      //   }
      // ]
      const res = web3.eth.abi.encodeParameters(
        ['string', 'uint256'],
        ['Hello, World!', '12345'])

      const info = [
          web3.eth.abi.encodeFunctionCall({
            name: 'test2PlayFirst',
            type: 'function',
            inputs: [{ type: 'bytes', name: 'data' }],
          }, [res])
          // web3.eth.abi.encodeFunctionCall({
          //   name: 'test2PlaySecond',
          //   type: 'function',
          //   inputs: [{ type: 'uint256', name: 'data' }],
          // }, [12345]),
      ]

      console.log(res);

      setFunctionInfo(info);
    }
  }, [web3]);

  useEffect(() => {
    console.log(functionInfo)
  }, [functionInfo])


  const sendData = async () => {
    console.log('??')
    const data = await testContract.methods.initialPlay(functionInfo).send({
      from : user.account,
      value : 0
  });
  console.log(data);
  }

  // function encodeFunctionData(info) {
  //   const contractAddress = info.contractAddress;
  //   const name = info.name;
  //   const args = info.args;
    
  //   return web3.eth.abi.encodeFunctionCall({
  //       name: name,
  //       type: 'function',
  //       inputs: [{
  //           type: 'bytes',
  //           name: 'data'
  //       }]
  //   }, args, contractAddress);
  // } 


  return (
    <>
    <button onClick={() => {sendData()}}>Data 전송</button>
    </>
  )
}

export default App;
