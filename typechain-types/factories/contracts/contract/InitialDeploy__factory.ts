/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */
import {
  Contract,
  ContractFactory,
  ContractTransactionResponse,
  Interface,
} from "ethers";
import type {
  Signer,
  AddressLike,
  ContractDeployTransaction,
  ContractRunner,
} from "ethers";
import type { NonPayableOverrides } from "../../../common";
import type {
  InitialDeploy,
  InitialDeployInterface,
} from "../../../contracts/contract/InitialDeploy";

const _abi = [
  {
    inputs: [
      {
        internalType: "address",
        name: "_dataAddress",
        type: "address",
      },
    ],
    stateMutability: "nonpayable",
    type: "constructor",
  },
] as const;

const _bytecode =
  "0x60806040523480156200001157600080fd5b506040516200400e3803806200400e83398181016040528101906200003791906200043c565b60006040516200004790620003b6565b620000529062000549565b604051809103906000f0801580156200006f573d6000803e3d6000fd5b50905060006127106040516200008590620003c4565b6200009191906200068c565b604051809103906000f080158015620000ae573d6000803e3d6000fd5b5090506000612710604051620000c490620003c4565b620000d0919062000788565b604051809103906000f080158015620000ed573d6000803e3d6000fd5b50905060006127106040516200010390620003c4565b6200010f919062000884565b604051809103906000f0801580156200012c573d6000803e3d6000fd5b509050846000806101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff16021790555060008054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1663d48bfca7856040518263ffffffff1660e01b8152600401620001ca9190620008f1565b600060405180830381600087803b158015620001e557600080fd5b505af1158015620001fa573d6000803e3d6000fd5b5050505060008054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1663d48bfca7846040518263ffffffff1660e01b8152600401620002599190620008f1565b600060405180830381600087803b1580156200027457600080fd5b505af115801562000289573d6000803e3d6000fd5b5050505060008054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1663d48bfca7836040518263ffffffff1660e01b8152600401620002e89190620008f1565b600060405180830381600087803b1580156200030357600080fd5b505af115801562000318573d6000803e3d6000fd5b5050505060008054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1663d48bfca7826040518263ffffffff1660e01b8152600401620003779190620008f1565b600060405180830381600087803b1580156200039257600080fd5b505af1158015620003a7573d6000803e3d6000fd5b5050505050505050506200090e565b611c2d806200095c83390190565b611a85806200258983390190565b600080fd5b600073ffffffffffffffffffffffffffffffffffffffff82169050919050565b60006200040482620003d7565b9050919050565b6200041681620003f7565b81146200042257600080fd5b50565b60008151905062000436816200040b565b92915050565b600060208284031215620004555762000454620003d2565b5b6000620004658482850162000425565b91505092915050565b600082825260208201905092915050565b7f5772617070656420426f756e636520436f696e00000000000000000000000000600082015250565b6000620004b76013836200046e565b9150620004c4826200047f565b602082019050919050565b7f57424e4300000000000000000000000000000000000000000000000000000000600082015250565b6000620005076004836200046e565b91506200051482620004cf565b602082019050919050565b50565b6000620005316000836200046e565b91506200053e826200051f565b600082019050919050565b600060608201905081810360008301526200056481620004a8565b905081810360208301526200057981620004f8565b905081810360408301526200058e8162000522565b9050919050565b7f657468657265756d000000000000000000000000000000000000000000000000600082015250565b6000620005cd6008836200046e565b9150620005da8262000595565b602082019050919050565b7f4554480000000000000000000000000000000000000000000000000000000000600082015250565b60006200061d6003836200046e565b91506200062a82620005e5565b602082019050919050565b6000819050919050565b6000819050919050565b6000819050919050565b6000620006746200066e620006688462000635565b62000649565b6200063f565b9050919050565b620006868162000653565b82525050565b60006080820190508181036000830152620006a781620005be565b90508181036020830152620006bc816200060e565b9050620006cd60408301846200067b565b8181036060830152620006e08162000522565b905092915050565b7f5465746865720000000000000000000000000000000000000000000000000000600082015250565b6000620007206006836200046e565b91506200072d82620006e8565b602082019050919050565b7f5553445400000000000000000000000000000000000000000000000000000000600082015250565b6000620007706004836200046e565b91506200077d8262000738565b602082019050919050565b60006080820190508181036000830152620007a38162000711565b90508181036020830152620007b88162000761565b9050620007c960408301846200067b565b8181036060830152620007dc8162000522565b905092915050565b7f42696e616e636520436f696e0000000000000000000000000000000000000000600082015250565b60006200081c600c836200046e565b91506200082982620007e4565b602082019050919050565b7f424e420000000000000000000000000000000000000000000000000000000000600082015250565b60006200086c6003836200046e565b9150620008798262000834565b602082019050919050565b600060808201905081810360008301526200089f816200080d565b90508181036020830152620008b4816200085d565b9050620008c560408301846200067b565b8181036060830152620008d88162000522565b905092915050565b620008eb81620003f7565b82525050565b6000602082019050620009086000830184620008e0565b92915050565b603f806200091d6000396000f3fe6080604052600080fdfea2646970667358221220029440d29671d3c18aa0f772ec54ae1dd3331f2ac19122cdf3259e23ac56209964736f6c63430008140033608060405260126003553480156200001657600080fd5b5060405162001c2d38038062001c2d83398181016040528101906200003c91906200032a565b828260008383600090816200005291906200062e565b5082600190816200006491906200062e565b506200007681620000c360201b60201c565b600290816200008691906200062e565b50620000b633600354600a6200009d919062000898565b84620000aa9190620008e9565b620000ff60201b60201c565b50505050505050620009d9565b6060620000d56200017660201b60201c565b82604051602001620000e992919062000976565b6040516020818303038152906040529050919050565b80600560008473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060008282546200015091906200099e565b9250508190555080600460008282546200016b91906200099e565b925050819055505050565b606060405180606001604052806035815260200162001bf860359139905090565b6000604051905090565b600080fd5b600080fd5b600080fd5b600080fd5b6000601f19601f8301169050919050565b7f4e487b7100000000000000000000000000000000000000000000000000000000600052604160045260246000fd5b6200020082620001b5565b810181811067ffffffffffffffff82111715620002225762000221620001c6565b5b80604052505050565b60006200023762000197565b9050620002458282620001f5565b919050565b600067ffffffffffffffff821115620002685762000267620001c6565b5b6200027382620001b5565b9050602081019050919050565b60005b83811015620002a057808201518184015260208101905062000283565b60008484015250505050565b6000620002c3620002bd846200024a565b6200022b565b905082815260208101848484011115620002e257620002e1620001b0565b5b620002ef84828562000280565b509392505050565b600082601f8301126200030f576200030e620001ab565b5b815162000321848260208601620002ac565b91505092915050565b600080600060608486031215620003465762000345620001a1565b5b600084015167ffffffffffffffff811115620003675762000366620001a6565b5b6200037586828701620002f7565b935050602084015167ffffffffffffffff811115620003995762000398620001a6565b5b620003a786828701620002f7565b925050604084015167ffffffffffffffff811115620003cb57620003ca620001a6565b5b620003d986828701620002f7565b9150509250925092565b600081519050919050565b7f4e487b7100000000000000000000000000000000000000000000000000000000600052602260045260246000fd5b600060028204905060018216806200043657607f821691505b6020821081036200044c576200044b620003ee565b5b50919050565b60008190508160005260206000209050919050565b60006020601f8301049050919050565b600082821b905092915050565b600060088302620004b67fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff8262000477565b620004c2868362000477565b95508019841693508086168417925050509392505050565b6000819050919050565b6000819050919050565b60006200050f620005096200050384620004da565b620004e4565b620004da565b9050919050565b6000819050919050565b6200052b83620004ee565b620005436200053a8262000516565b84845462000484565b825550505050565b600090565b6200055a6200054b565b6200056781848462000520565b505050565b5b818110156200058f576200058360008262000550565b6001810190506200056d565b5050565b601f821115620005de57620005a88162000452565b620005b38462000467565b81016020851015620005c3578190505b620005db620005d28562000467565b8301826200056c565b50505b505050565b600082821c905092915050565b60006200060360001984600802620005e3565b1980831691505092915050565b60006200061e8383620005f0565b9150826002028217905092915050565b6200063982620003e3565b67ffffffffffffffff811115620006555762000654620001c6565b5b6200066182546200041d565b6200066e82828562000593565b600060209050601f831160018114620006a6576000841562000691578287015190505b6200069d858262000610565b8655506200070d565b601f198416620006b68662000452565b60005b82811015620006e057848901518255600182019150602085019450602081019050620006b9565b86831015620007005784890151620006fc601f891682620005f0565b8355505b6001600288020188555050505b505050505050565b7f4e487b7100000000000000000000000000000000000000000000000000000000600052601160045260246000fd5b60008160011c9050919050565b6000808291508390505b6001851115620007a3578086048111156200077b576200077a62000715565b5b60018516156200078b5780820291505b80810290506200079b8562000744565b94506200075b565b94509492505050565b600082620007be576001905062000891565b81620007ce576000905062000891565b8160018114620007e75760028114620007f25762000828565b600191505062000891565b60ff84111562000807576200080662000715565b5b8360020a91508482111562000821576200082062000715565b5b5062000891565b5060208310610133831016604e8410600b8410161715620008625782820a9050838111156200085c576200085b62000715565b5b62000891565b62000871848484600162000751565b925090508184048111156200088b576200088a62000715565b5b81810290505b9392505050565b6000620008a582620004da565b9150620008b283620004da565b9250620008e17fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff8484620007ac565b905092915050565b6000620008f682620004da565b91506200090383620004da565b92508282026200091381620004da565b915082820484148315176200092d576200092c62000715565b5b5092915050565b600081905092915050565b60006200094c82620003e3565b62000958818562000934565b93506200096a81856020860162000280565b80840191505092915050565b60006200098482856200093f565b91506200099282846200093f565b91508190509392505050565b6000620009ab82620004da565b9150620009b883620004da565b9250828201905080821115620009d357620009d262000715565b5b92915050565b61120f80620009e96000396000f3fe6080604052600436106100f35760003560e01c806355b6ed5c1161008a578063a9059cbb11610059578063a9059cbb14610362578063b6b55f251461039f578063dd62ed3e146103bb578063eac989f8146103f8576100f3565b806355b6ed5c146102945780636161eb18146102d157806370a08231146102fa57806395d89b4114610337576100f3565b806327e235e3116100c657806327e235e3146101c85780632e1a7d4d146102055780634cf12d261461022e5780634e6ec2471461026b576100f3565b806306fdde03146100f8578063095ea7b31461012357806318160ddd1461016057806323b872dd1461018b575b600080fd5b34801561010457600080fd5b5061010d610423565b60405161011a9190610c78565b60405180910390f35b34801561012f57600080fd5b5061014a60048036038101906101459190610d42565b6104b1565b6040516101579190610d9d565b60405180910390f35b34801561016c57600080fd5b5061017561053e565b6040516101829190610dc7565b60405180910390f35b34801561019757600080fd5b506101b260048036038101906101ad9190610de2565b610544565b6040516101bf9190610d9d565b60405180910390f35b3480156101d457600080fd5b506101ef60048036038101906101ea9190610e35565b610719565b6040516101fc9190610dc7565b60405180910390f35b34801561021157600080fd5b5061022c60048036038101906102279190610e62565b610731565b005b34801561023a57600080fd5b5061025560048036038101906102509190610fc4565b61078c565b6040516102629190610c78565b60405180910390f35b34801561027757600080fd5b50610292600480360381019061028d9190610d42565b6107be565b005b3480156102a057600080fd5b506102bb60048036038101906102b6919061100d565b610831565b6040516102c89190610dc7565b60405180910390f35b3480156102dd57600080fd5b506102f860048036038101906102f39190610d42565b610856565b005b34801561030657600080fd5b50610321600480360381019061031c9190610e35565b6108c9565b60405161032e9190610dc7565b60405180910390f35b34801561034357600080fd5b5061034c610912565b6040516103599190610c78565b60405180910390f35b34801561036e57600080fd5b5061038960048036038101906103849190610d42565b6109a0565b6040516103969190610d9d565b60405180910390f35b6103b960048036038101906103b49190610e62565b610a58565b005b3480156103c757600080fd5b506103e260048036038101906103dd919061100d565b610ab3565b6040516103ef9190610dc7565b60405180910390f35b34801561040457600080fd5b5061040d610b3a565b60405161041a9190610c78565b60405180910390f35b600080546104309061107c565b80601f016020809104026020016040519081016040528092919081815260200182805461045c9061107c565b80156104a95780601f1061047e576101008083540402835291602001916104a9565b820191906000526020600020905b81548152906001019060200180831161048c57829003601f168201915b505050505081565b600081600660003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060008573ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020819055506001905092915050565b60045481565b600081600660008673ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000205410156105cf57600080fd5b81600660008673ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020600082825461065b91906110dc565b9250508190555081600560008673ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060008282546106b191906110dc565b9250508190555081600560008573ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060008282546107079190611110565b92505081905550600190509392505050565b60056020528060005260406000206000915090505481565b61073b3382610856565b3373ffffffffffffffffffffffffffffffffffffffff167f7fcf532c15f0a6db0bd6d0e038bea71d30d808c7d98cb3bf7268a95bf5081b65826040516107819190610dc7565b60405180910390a250565b6060610796610bc8565b826040516020016107a8929190611180565b6040516020818303038152906040529050919050565b80600560008473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020600082825461080d9190611110565b9250508190555080600460008282546108269190611110565b925050819055505050565b6006602052816000526040600020602052806000526040600020600091509150505481565b80600560008473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060008282546108a591906110dc565b9250508190555080600460008282546108be91906110dc565b925050819055505050565b6000600560008373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020549050919050565b6001805461091f9061107c565b80601f016020809104026020016040519081016040528092919081815260200182805461094b9061107c565b80156109985780601f1061096d57610100808354040283529160200191610998565b820191906000526020600020905b81548152906001019060200180831161097b57829003601f168201915b505050505081565b600081600560003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060008282546109f191906110dc565b9250508190555081600560008573ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000206000828254610a479190611110565b925050819055506001905092915050565b610a6233826107be565b3373ffffffffffffffffffffffffffffffffffffffff167fe1fffcc4923d04b559f4d29a8bfc6cda04eb5b0d3c460751c2402c5c5cc9109c82604051610aa89190610dc7565b60405180910390a250565b6000600660008473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060008373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002054905092915050565b60028054610b479061107c565b80601f0160208091040260200160405190810160405280929190818152602001828054610b739061107c565b8015610bc05780601f10610b9557610100808354040283529160200191610bc0565b820191906000526020600020905b815481529060010190602001808311610ba357829003601f168201915b505050505081565b60606040518060600160405280603581526020016111a560359139905090565b600081519050919050565b600082825260208201905092915050565b60005b83811015610c22578082015181840152602081019050610c07565b60008484015250505050565b6000601f19601f8301169050919050565b6000610c4a82610be8565b610c548185610bf3565b9350610c64818560208601610c04565b610c6d81610c2e565b840191505092915050565b60006020820190508181036000830152610c928184610c3f565b905092915050565b6000604051905090565b600080fd5b600080fd5b600073ffffffffffffffffffffffffffffffffffffffff82169050919050565b6000610cd982610cae565b9050919050565b610ce981610cce565b8114610cf457600080fd5b50565b600081359050610d0681610ce0565b92915050565b6000819050919050565b610d1f81610d0c565b8114610d2a57600080fd5b50565b600081359050610d3c81610d16565b92915050565b60008060408385031215610d5957610d58610ca4565b5b6000610d6785828601610cf7565b9250506020610d7885828601610d2d565b9150509250929050565b60008115159050919050565b610d9781610d82565b82525050565b6000602082019050610db26000830184610d8e565b92915050565b610dc181610d0c565b82525050565b6000602082019050610ddc6000830184610db8565b92915050565b600080600060608486031215610dfb57610dfa610ca4565b5b6000610e0986828701610cf7565b9350506020610e1a86828701610cf7565b9250506040610e2b86828701610d2d565b9150509250925092565b600060208284031215610e4b57610e4a610ca4565b5b6000610e5984828501610cf7565b91505092915050565b600060208284031215610e7857610e77610ca4565b5b6000610e8684828501610d2d565b91505092915050565b600080fd5b600080fd5b7f4e487b7100000000000000000000000000000000000000000000000000000000600052604160045260246000fd5b610ed182610c2e565b810181811067ffffffffffffffff82111715610ef057610eef610e99565b5b80604052505050565b6000610f03610c9a565b9050610f0f8282610ec8565b919050565b600067ffffffffffffffff821115610f2f57610f2e610e99565b5b610f3882610c2e565b9050602081019050919050565b82818337600083830152505050565b6000610f67610f6284610f14565b610ef9565b905082815260208101848484011115610f8357610f82610e94565b5b610f8e848285610f45565b509392505050565b600082601f830112610fab57610faa610e8f565b5b8135610fbb848260208601610f54565b91505092915050565b600060208284031215610fda57610fd9610ca4565b5b600082013567ffffffffffffffff811115610ff857610ff7610ca9565b5b61100484828501610f96565b91505092915050565b6000806040838503121561102457611023610ca4565b5b600061103285828601610cf7565b925050602061104385828601610cf7565b9150509250929050565b7f4e487b7100000000000000000000000000000000000000000000000000000000600052602260045260246000fd5b6000600282049050600182168061109457607f821691505b6020821081036110a7576110a661104d565b5b50919050565b7f4e487b7100000000000000000000000000000000000000000000000000000000600052601160045260246000fd5b60006110e782610d0c565b91506110f283610d0c565b925082820390508181111561110a576111096110ad565b5b92915050565b600061111b82610d0c565b915061112683610d0c565b925082820190508082111561113e5761113d6110ad565b5b92915050565b600081905092915050565b600061115a82610be8565b6111648185611144565b9350611174818560208601610c04565b80840191505092915050565b600061118c828561114f565b9150611198828461114f565b9150819050939250505056fe68747470733a2f2f6372696d736f6e2d67656e65726f75732d616e742d3339352e6d7970696e6174612e636c6f75642f697066732fa264697066735822122088c857459f148b1d12fdaa863d52f6546c6e3b7dc483d89eab9d9d190b347c6964736f6c6343000814003368747470733a2f2f6372696d736f6e2d67656e65726f75732d616e742d3339352e6d7970696e6174612e636c6f75642f697066732f608060405260126003553480156200001657600080fd5b5060405162001a8538038062001a8583398181016040528101906200003c91906200035d565b83600090816200004d91906200066d565b5082600190816200005f91906200066d565b506200007181620000bb60201b60201c565b600290816200008191906200066d565b50620000b133600354600a620000989190620008d7565b84620000a5919062000928565b620000f760201b60201c565b5050505062000a18565b6060620000cd6200016e60201b60201c565b82604051602001620000e1929190620009b5565b6040516020818303038152906040529050919050565b80600560008473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000206000828254620001489190620009dd565b925050819055508060046000828254620001639190620009dd565b925050819055505050565b606060405180606001604052806035815260200162001a5060359139905090565b6000604051905090565b600080fd5b600080fd5b600080fd5b600080fd5b6000601f19601f8301169050919050565b7f4e487b7100000000000000000000000000000000000000000000000000000000600052604160045260246000fd5b620001f882620001ad565b810181811067ffffffffffffffff821117156200021a5762000219620001be565b5b80604052505050565b60006200022f6200018f565b90506200023d8282620001ed565b919050565b600067ffffffffffffffff82111562000260576200025f620001be565b5b6200026b82620001ad565b9050602081019050919050565b60005b83811015620002985780820151818401526020810190506200027b565b60008484015250505050565b6000620002bb620002b58462000242565b62000223565b905082815260208101848484011115620002da57620002d9620001a8565b5b620002e784828562000278565b509392505050565b600082601f830112620003075762000306620001a3565b5b815162000319848260208601620002a4565b91505092915050565b6000819050919050565b620003378162000322565b81146200034357600080fd5b50565b60008151905062000357816200032c565b92915050565b600080600080608085870312156200037a576200037962000199565b5b600085015167ffffffffffffffff8111156200039b576200039a6200019e565b5b620003a987828801620002ef565b945050602085015167ffffffffffffffff811115620003cd57620003cc6200019e565b5b620003db87828801620002ef565b9350506040620003ee8782880162000346565b925050606085015167ffffffffffffffff8111156200041257620004116200019e565b5b6200042087828801620002ef565b91505092959194509250565b600081519050919050565b7f4e487b7100000000000000000000000000000000000000000000000000000000600052602260045260246000fd5b600060028204905060018216806200047f57607f821691505b60208210810362000495576200049462000437565b5b50919050565b60008190508160005260206000209050919050565b60006020601f8301049050919050565b600082821b905092915050565b600060088302620004ff7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff82620004c0565b6200050b8683620004c0565b95508019841693508086168417925050509392505050565b6000819050919050565b60006200054e62000548620005428462000322565b62000523565b62000322565b9050919050565b6000819050919050565b6200056a836200052d565b62000582620005798262000555565b848454620004cd565b825550505050565b600090565b620005996200058a565b620005a68184846200055f565b505050565b5b81811015620005ce57620005c26000826200058f565b600181019050620005ac565b5050565b601f8211156200061d57620005e7816200049b565b620005f284620004b0565b8101602085101562000602578190505b6200061a6200061185620004b0565b830182620005ab565b50505b505050565b600082821c905092915050565b6000620006426000198460080262000622565b1980831691505092915050565b60006200065d83836200062f565b9150826002028217905092915050565b62000678826200042c565b67ffffffffffffffff811115620006945762000693620001be565b5b620006a0825462000466565b620006ad828285620005d2565b600060209050601f831160018114620006e55760008415620006d0578287015190505b620006dc85826200064f565b8655506200074c565b601f198416620006f5866200049b565b60005b828110156200071f57848901518255600182019150602085019450602081019050620006f8565b868310156200073f57848901516200073b601f8916826200062f565b8355505b6001600288020188555050505b505050505050565b7f4e487b7100000000000000000000000000000000000000000000000000000000600052601160045260246000fd5b60008160011c9050919050565b6000808291508390505b6001851115620007e257808604811115620007ba57620007b962000754565b5b6001851615620007ca5780820291505b8081029050620007da8562000783565b94506200079a565b94509492505050565b600082620007fd5760019050620008d0565b816200080d5760009050620008d0565b8160018114620008265760028114620008315762000867565b6001915050620008d0565b60ff84111562000846576200084562000754565b5b8360020a91508482111562000860576200085f62000754565b5b50620008d0565b5060208310610133831016604e8410600b8410161715620008a15782820a9050838111156200089b576200089a62000754565b5b620008d0565b620008b0848484600162000790565b92509050818404811115620008ca57620008c962000754565b5b81810290505b9392505050565b6000620008e48262000322565b9150620008f18362000322565b9250620009207fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff8484620007eb565b905092915050565b6000620009358262000322565b9150620009428362000322565b9250828202620009528162000322565b915082820484148315176200096c576200096b62000754565b5b5092915050565b600081905092915050565b60006200098b826200042c565b62000997818562000973565b9350620009a981856020860162000278565b80840191505092915050565b6000620009c382856200097e565b9150620009d182846200097e565b91508190509392505050565b6000620009ea8262000322565b9150620009f78362000322565b925082820190508082111562000a125762000a1162000754565b5b92915050565b6110288062000a286000396000f3fe608060405234801561001057600080fd5b50600436106100ea5760003560e01c806355b6ed5c1161008c57806395d89b411161006657806395d89b4114610283578063a9059cbb146102a1578063dd62ed3e146102d1578063eac989f814610301576100ea565b806355b6ed5c146102075780636161eb181461023757806370a0823114610253576100ea565b806323b872dd116100c857806323b872dd1461015b57806327e235e31461018b5780634cf12d26146101bb5780634e6ec247146101eb576100ea565b806306fdde03146100ef578063095ea7b31461010d57806318160ddd1461013d575b600080fd5b6100f761031f565b6040516101049190610abe565b60405180910390f35b61012760048036038101906101229190610b88565b6103ad565b6040516101349190610be3565b60405180910390f35b61014561043a565b6040516101529190610c0d565b60405180910390f35b61017560048036038101906101709190610c28565b610440565b6040516101829190610be3565b60405180910390f35b6101a560048036038101906101a09190610c7b565b610615565b6040516101b29190610c0d565b60405180910390f35b6101d560048036038101906101d09190610ddd565b61062d565b6040516101e29190610abe565b60405180910390f35b61020560048036038101906102009190610b88565b61065f565b005b610221600480360381019061021c9190610e26565b6106d2565b60405161022e9190610c0d565b60405180910390f35b610251600480360381019061024c9190610b88565b6106f7565b005b61026d60048036038101906102689190610c7b565b61076a565b60405161027a9190610c0d565b60405180910390f35b61028b6107b3565b6040516102989190610abe565b60405180910390f35b6102bb60048036038101906102b69190610b88565b610841565b6040516102c89190610be3565b60405180910390f35b6102eb60048036038101906102e69190610e26565b6108f9565b6040516102f89190610c0d565b60405180910390f35b610309610980565b6040516103169190610abe565b60405180910390f35b6000805461032c90610e95565b80601f016020809104026020016040519081016040528092919081815260200182805461035890610e95565b80156103a55780601f1061037a576101008083540402835291602001916103a5565b820191906000526020600020905b81548152906001019060200180831161038857829003601f168201915b505050505081565b600081600660003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060008573ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020819055506001905092915050565b60045481565b600081600660008673ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000205410156104cb57600080fd5b81600660008673ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060008282546105579190610ef5565b9250508190555081600560008673ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060008282546105ad9190610ef5565b9250508190555081600560008573ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060008282546106039190610f29565b92505081905550600190509392505050565b60056020528060005260406000206000915090505481565b6060610637610a0e565b82604051602001610649929190610f99565b6040516020818303038152906040529050919050565b80600560008473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060008282546106ae9190610f29565b9250508190555080600460008282546106c79190610f29565b925050819055505050565b6006602052816000526040600020602052806000526040600020600091509150505481565b80600560008473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060008282546107469190610ef5565b92505081905550806004600082825461075f9190610ef5565b925050819055505050565b6000600560008373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020549050919050565b600180546107c090610e95565b80601f01602080910402602001604051908101604052809291908181526020018280546107ec90610e95565b80156108395780601f1061080e57610100808354040283529160200191610839565b820191906000526020600020905b81548152906001019060200180831161081c57829003601f168201915b505050505081565b600081600560003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060008282546108929190610ef5565b9250508190555081600560008573ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060008282546108e89190610f29565b925050819055506001905092915050565b6000600660008473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060008373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002054905092915050565b6002805461098d90610e95565b80601f01602080910402602001604051908101604052809291908181526020018280546109b990610e95565b8015610a065780601f106109db57610100808354040283529160200191610a06565b820191906000526020600020905b8154815290600101906020018083116109e957829003601f168201915b505050505081565b6060604051806060016040528060358152602001610fbe60359139905090565b600081519050919050565b600082825260208201905092915050565b60005b83811015610a68578082015181840152602081019050610a4d565b60008484015250505050565b6000601f19601f8301169050919050565b6000610a9082610a2e565b610a9a8185610a39565b9350610aaa818560208601610a4a565b610ab381610a74565b840191505092915050565b60006020820190508181036000830152610ad88184610a85565b905092915050565b6000604051905090565b600080fd5b600080fd5b600073ffffffffffffffffffffffffffffffffffffffff82169050919050565b6000610b1f82610af4565b9050919050565b610b2f81610b14565b8114610b3a57600080fd5b50565b600081359050610b4c81610b26565b92915050565b6000819050919050565b610b6581610b52565b8114610b7057600080fd5b50565b600081359050610b8281610b5c565b92915050565b60008060408385031215610b9f57610b9e610aea565b5b6000610bad85828601610b3d565b9250506020610bbe85828601610b73565b9150509250929050565b60008115159050919050565b610bdd81610bc8565b82525050565b6000602082019050610bf86000830184610bd4565b92915050565b610c0781610b52565b82525050565b6000602082019050610c226000830184610bfe565b92915050565b600080600060608486031215610c4157610c40610aea565b5b6000610c4f86828701610b3d565b9350506020610c6086828701610b3d565b9250506040610c7186828701610b73565b9150509250925092565b600060208284031215610c9157610c90610aea565b5b6000610c9f84828501610b3d565b91505092915050565b600080fd5b600080fd5b7f4e487b7100000000000000000000000000000000000000000000000000000000600052604160045260246000fd5b610cea82610a74565b810181811067ffffffffffffffff82111715610d0957610d08610cb2565b5b80604052505050565b6000610d1c610ae0565b9050610d288282610ce1565b919050565b600067ffffffffffffffff821115610d4857610d47610cb2565b5b610d5182610a74565b9050602081019050919050565b82818337600083830152505050565b6000610d80610d7b84610d2d565b610d12565b905082815260208101848484011115610d9c57610d9b610cad565b5b610da7848285610d5e565b509392505050565b600082601f830112610dc457610dc3610ca8565b5b8135610dd4848260208601610d6d565b91505092915050565b600060208284031215610df357610df2610aea565b5b600082013567ffffffffffffffff811115610e1157610e10610aef565b5b610e1d84828501610daf565b91505092915050565b60008060408385031215610e3d57610e3c610aea565b5b6000610e4b85828601610b3d565b9250506020610e5c85828601610b3d565b9150509250929050565b7f4e487b7100000000000000000000000000000000000000000000000000000000600052602260045260246000fd5b60006002820490506001821680610ead57607f821691505b602082108103610ec057610ebf610e66565b5b50919050565b7f4e487b7100000000000000000000000000000000000000000000000000000000600052601160045260246000fd5b6000610f0082610b52565b9150610f0b83610b52565b9250828203905081811115610f2357610f22610ec6565b5b92915050565b6000610f3482610b52565b9150610f3f83610b52565b9250828201905080821115610f5757610f56610ec6565b5b92915050565b600081905092915050565b6000610f7382610a2e565b610f7d8185610f5d565b9350610f8d818560208601610a4a565b80840191505092915050565b6000610fa58285610f68565b9150610fb18284610f68565b9150819050939250505056fe68747470733a2f2f6372696d736f6e2d67656e65726f75732d616e742d3339352e6d7970696e6174612e636c6f75642f697066732fa26469706673582212207f6b5a15e3159c8aeaed0c6aee0cb1dbbf1288e1d1c6d2ce65cea88b9d51bd5c64736f6c6343000814003368747470733a2f2f6372696d736f6e2d67656e65726f75732d616e742d3339352e6d7970696e6174612e636c6f75642f697066732f";

type InitialDeployConstructorParams =
  | [signer?: Signer]
  | ConstructorParameters<typeof ContractFactory>;

const isSuperArgs = (
  xs: InitialDeployConstructorParams
): xs is ConstructorParameters<typeof ContractFactory> => xs.length > 1;

export class InitialDeploy__factory extends ContractFactory {
  constructor(...args: InitialDeployConstructorParams) {
    if (isSuperArgs(args)) {
      super(...args);
    } else {
      super(_abi, _bytecode, args[0]);
    }
  }

  override getDeployTransaction(
    _dataAddress: AddressLike,
    overrides?: NonPayableOverrides & { from?: string }
  ): Promise<ContractDeployTransaction> {
    return super.getDeployTransaction(_dataAddress, overrides || {});
  }
  override deploy(
    _dataAddress: AddressLike,
    overrides?: NonPayableOverrides & { from?: string }
  ) {
    return super.deploy(_dataAddress, overrides || {}) as Promise<
      InitialDeploy & {
        deploymentTransaction(): ContractTransactionResponse;
      }
    >;
  }
  override connect(runner: ContractRunner | null): InitialDeploy__factory {
    return super.connect(runner) as InitialDeploy__factory;
  }

  static readonly bytecode = _bytecode;
  static readonly abi = _abi;
  static createInterface(): InitialDeployInterface {
    return new Interface(_abi) as InitialDeployInterface;
  }
  static connect(
    address: string,
    runner?: ContractRunner | null
  ): InitialDeploy {
    return new Contract(address, _abi, runner) as unknown as InitialDeploy;
  }
}
