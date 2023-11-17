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
  "0x608060405234801562000010575f80fd5b5060405162003c2138038062003c2183398181016040528101906200003691906200040d565b5f60405162000045906200038c565b620000509062000510565b604051809103905ff0801580156200006a573d5f803e3d5ffd5b5090505f6127106040516200007f906200039a565b6200008b919062000649565b604051809103905ff080158015620000a5573d5f803e3d5ffd5b5090505f612710604051620000ba906200039a565b620000c691906200073f565b604051809103905ff080158015620000e0573d5f803e3d5ffd5b5090505f612710604051620000f5906200039a565b62000101919062000835565b604051809103905ff0801580156200011b573d5f803e3d5ffd5b509050845f806101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff1602179055505f8054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1663d48bfca7856040518263ffffffff1660e01b8152600401620001b79190620008a0565b5f604051808303815f87803b158015620001cf575f80fd5b505af1158015620001e2573d5f803e3d5ffd5b505050505f8054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1663d48bfca7846040518263ffffffff1660e01b8152600401620002409190620008a0565b5f604051808303815f87803b15801562000258575f80fd5b505af11580156200026b573d5f803e3d5ffd5b505050505f8054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1663d48bfca7836040518263ffffffff1660e01b8152600401620002c99190620008a0565b5f604051808303815f87803b158015620002e1575f80fd5b505af1158015620002f4573d5f803e3d5ffd5b505050505f8054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1663d48bfca7826040518263ffffffff1660e01b8152600401620003529190620008a0565b5f604051808303815f87803b1580156200036a575f80fd5b505af11580156200037d573d5f803e3d5ffd5b505050505050505050620008bb565b611a5a806200090683390190565b6118c1806200236083390190565b5f80fd5b5f73ffffffffffffffffffffffffffffffffffffffff82169050919050565b5f620003d782620003ac565b9050919050565b620003e981620003cb565b8114620003f4575f80fd5b50565b5f815190506200040781620003de565b92915050565b5f60208284031215620004255762000424620003a8565b5b5f6200043484828501620003f7565b91505092915050565b5f82825260208201905092915050565b7f5772617070656420426f756e636520436f696e000000000000000000000000005f82015250565b5f620004836013836200043d565b915062000490826200044d565b602082019050919050565b7f57424e43000000000000000000000000000000000000000000000000000000005f82015250565b5f620004d16004836200043d565b9150620004de826200049b565b602082019050919050565b50565b5f620004f95f836200043d565b91506200050682620004e9565b5f82019050919050565b5f6060820190508181035f830152620005298162000475565b905081810360208301526200053e81620004c3565b905081810360408301526200055381620004ec565b9050919050565b7f657468657265756d0000000000000000000000000000000000000000000000005f82015250565b5f620005906008836200043d565b91506200059d826200055a565b602082019050919050565b7f45544800000000000000000000000000000000000000000000000000000000005f82015250565b5f620005de6003836200043d565b9150620005eb82620005a8565b602082019050919050565b5f819050919050565b5f819050919050565b5f819050919050565b5f620006316200062b6200062584620005f6565b62000608565b620005ff565b9050919050565b620006438162000611565b82525050565b5f6080820190508181035f830152620006628162000582565b905081810360208301526200067781620005d0565b905062000688604083018462000638565b81810360608301526200069b81620004ec565b905092915050565b7f54657468657200000000000000000000000000000000000000000000000000005f82015250565b5f620006d96006836200043d565b9150620006e682620006a3565b602082019050919050565b7f55534454000000000000000000000000000000000000000000000000000000005f82015250565b5f620007276004836200043d565b91506200073482620006f1565b602082019050919050565b5f6080820190508181035f8301526200075881620006cb565b905081810360208301526200076d8162000719565b90506200077e604083018462000638565b81810360608301526200079181620004ec565b905092915050565b7f42696e616e636520436f696e00000000000000000000000000000000000000005f82015250565b5f620007cf600c836200043d565b9150620007dc8262000799565b602082019050919050565b7f424e4200000000000000000000000000000000000000000000000000000000005f82015250565b5f6200081d6003836200043d565b91506200082a82620007e7565b602082019050919050565b5f6080820190508181035f8301526200084e81620007c1565b9050818103602083015262000863816200080f565b905062000874604083018462000638565b81810360608301526200088781620004ec565b905092915050565b6200089a81620003cb565b82525050565b5f602082019050620008b55f8301846200088f565b92915050565b603e80620008c85f395ff3fe60806040525f80fdfea26469706673582212204b076817c20060d841a8bce68ed7a5cff6adaf903ff9eb4d3462bd0a8e98abc964736f6c634300081400336080604052601260035534801562000015575f80fd5b5060405162001a5a38038062001a5a83398181016040528101906200003b919062000315565b82825f83835f90816200004f919062000602565b50826001908162000061919062000602565b506200007381620000c060201b60201c565b6002908162000083919062000602565b50620000b333600354600a6200009a919062000863565b84620000a79190620008b3565b620000fc60201b60201c565b505050505050506200099e565b6060620000d26200016f60201b60201c565b82604051602001620000e69291906200093d565b6040516020818303038152906040529050919050565b8060055f8473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020015f205f8282546200014a919062000964565b925050819055508060045f82825462000164919062000964565b925050819055505050565b606060405180606001604052806035815260200162001a2560359139905090565b5f604051905090565b5f80fd5b5f80fd5b5f80fd5b5f80fd5b5f601f19601f8301169050919050565b7f4e487b71000000000000000000000000000000000000000000000000000000005f52604160045260245ffd5b620001f182620001a9565b810181811067ffffffffffffffff82111715620002135762000212620001b9565b5b80604052505050565b5f6200022762000190565b9050620002358282620001e6565b919050565b5f67ffffffffffffffff821115620002575762000256620001b9565b5b6200026282620001a9565b9050602081019050919050565b5f5b838110156200028e57808201518184015260208101905062000271565b5f8484015250505050565b5f620002af620002a9846200023a565b6200021c565b905082815260208101848484011115620002ce57620002cd620001a5565b5b620002db8482856200026f565b509392505050565b5f82601f830112620002fa57620002f9620001a1565b5b81516200030c84826020860162000299565b91505092915050565b5f805f606084860312156200032f576200032e62000199565b5b5f84015167ffffffffffffffff8111156200034f576200034e6200019d565b5b6200035d86828701620002e3565b935050602084015167ffffffffffffffff8111156200038157620003806200019d565b5b6200038f86828701620002e3565b925050604084015167ffffffffffffffff811115620003b357620003b26200019d565b5b620003c186828701620002e3565b9150509250925092565b5f81519050919050565b7f4e487b71000000000000000000000000000000000000000000000000000000005f52602260045260245ffd5b5f60028204905060018216806200041a57607f821691505b60208210810362000430576200042f620003d5565b5b50919050565b5f819050815f5260205f209050919050565b5f6020601f8301049050919050565b5f82821b905092915050565b5f60088302620004947fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff8262000457565b620004a0868362000457565b95508019841693508086168417925050509392505050565b5f819050919050565b5f819050919050565b5f620004ea620004e4620004de84620004b8565b620004c1565b620004b8565b9050919050565b5f819050919050565b6200050583620004ca565b6200051d6200051482620004f1565b84845462000463565b825550505050565b5f90565b6200053362000525565b62000540818484620004fa565b505050565b5b8181101562000567576200055b5f8262000529565b60018101905062000546565b5050565b601f821115620005b657620005808162000436565b6200058b8462000448565b810160208510156200059b578190505b620005b3620005aa8562000448565b83018262000545565b50505b505050565b5f82821c905092915050565b5f620005d85f1984600802620005bb565b1980831691505092915050565b5f620005f28383620005c7565b9150826002028217905092915050565b6200060d82620003cb565b67ffffffffffffffff811115620006295762000628620001b9565b5b62000635825462000402565b620006428282856200056b565b5f60209050601f83116001811462000678575f841562000663578287015190505b6200066f8582620005e5565b865550620006de565b601f198416620006888662000436565b5f5b82811015620006b1578489015182556001820191506020850194506020810190506200068a565b86831015620006d15784890151620006cd601f891682620005c7565b8355505b6001600288020188555050505b505050505050565b7f4e487b71000000000000000000000000000000000000000000000000000000005f52601160045260245ffd5b5f8160011c9050919050565b5f808291508390505b60018511156200077057808604811115620007485762000747620006e6565b5b6001851615620007585780820291505b8081029050620007688562000713565b945062000728565b94509492505050565b5f826200078a57600190506200085c565b8162000799575f90506200085c565b8160018114620007b25760028114620007bd57620007f3565b60019150506200085c565b60ff841115620007d257620007d1620006e6565b5b8360020a915084821115620007ec57620007eb620006e6565b5b506200085c565b5060208310610133831016604e8410600b84101617156200082d5782820a905083811115620008275762000826620006e6565b5b6200085c565b6200083c84848460016200071f565b92509050818404811115620008565762000855620006e6565b5b81810290505b9392505050565b5f6200086f82620004b8565b91506200087c83620004b8565b9250620008ab7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff848462000779565b905092915050565b5f620008bf82620004b8565b9150620008cc83620004b8565b9250828202620008dc81620004b8565b91508282048414831517620008f657620008f5620006e6565b5b5092915050565b5f81905092915050565b5f6200091382620003cb565b6200091f8185620008fd565b9350620009318185602086016200026f565b80840191505092915050565b5f6200094a828562000907565b915062000958828462000907565b91508190509392505050565b5f6200097082620004b8565b91506200097d83620004b8565b9250828201905080821115620009985762000997620006e6565b5b92915050565b61107980620009ac5f395ff3fe6080604052600436106100f2575f3560e01c806355b6ed5c11610089578063a9059cbb11610058578063a9059cbb14610354578063b6b55f2514610390578063dd62ed3e146103ac578063eac989f8146103e8576100f2565b806355b6ed5c1461028a5780636161eb18146102c657806370a08231146102ee57806395d89b411461032a576100f2565b806327e235e3116100c557806327e235e3146101c25780632e1a7d4d146101fe5780634cf12d26146102265780634e6ec24714610262576100f2565b806306fdde03146100f6578063095ea7b31461012057806318160ddd1461015c57806323b872dd14610186575b5f80fd5b348015610101575f80fd5b5061010a610412565b6040516101179190610b13565b60405180910390f35b34801561012b575f80fd5b5061014660048036038101906101419190610bd1565b61049d565b6040516101539190610c29565b60405180910390f35b348015610167575f80fd5b50610170610525565b60405161017d9190610c51565b60405180910390f35b348015610191575f80fd5b506101ac60048036038101906101a79190610c6a565b61052b565b6040516101b99190610c29565b60405180910390f35b3480156101cd575f80fd5b506101e860048036038101906101e39190610cba565b6105dd565b6040516101f59190610c51565b60405180910390f35b348015610209575f80fd5b50610224600480360381019061021f9190610ce5565b6105f2565b005b348015610231575f80fd5b5061024c60048036038101906102479190610e3c565b61064d565b6040516102599190610b13565b60405180910390f35b34801561026d575f80fd5b5061028860048036038101906102839190610bd1565b61067f565b005b348015610295575f80fd5b506102b060048036038101906102ab9190610e83565b6106ee565b6040516102bd9190610c51565b60405180910390f35b3480156102d1575f80fd5b506102ec60048036038101906102e79190610bd1565b61070e565b005b3480156102f9575f80fd5b50610314600480360381019061030f9190610cba565b61077d565b6040516103219190610c51565b60405180910390f35b348015610335575f80fd5b5061033e6107c3565b60405161034b9190610b13565b60405180910390f35b34801561035f575f80fd5b5061037a60048036038101906103759190610bd1565b61084f565b6040516103879190610c29565b60405180910390f35b6103aa60048036038101906103a59190610ce5565b610900565b005b3480156103b7575f80fd5b506103d260048036038101906103cd9190610e83565b61095b565b6040516103df9190610c51565b60405180910390f35b3480156103f3575f80fd5b506103fc6109dd565b6040516104099190610b13565b60405180910390f35b5f805461041e90610eee565b80601f016020809104026020016040519081016040528092919081815260200182805461044a90610eee565b80156104955780601f1061046c57610100808354040283529160200191610495565b820191905f5260205f20905b81548152906001019060200180831161047857829003601f168201915b505050505081565b5f8160065f3373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020015f205f8573ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020015f20819055506001905092915050565b60045481565b5f8160055f8673ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020015f205f8282546105789190610f4b565b925050819055508160055f8573ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020015f205f8282546105cb9190610f7e565b92505081905550600190509392505050565b6005602052805f5260405f205f915090505481565b6105fc338261070e565b3373ffffffffffffffffffffffffffffffffffffffff167f7fcf532c15f0a6db0bd6d0e038bea71d30d808c7d98cb3bf7268a95bf5081b65826040516106429190610c51565b60405180910390a250565b6060610657610a69565b82604051602001610669929190610feb565b6040516020818303038152906040529050919050565b8060055f8473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020015f205f8282546106cb9190610f7e565b925050819055508060045f8282546106e39190610f7e565b925050819055505050565b6006602052815f5260405f20602052805f5260405f205f91509150505481565b8060055f8473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020015f205f82825461075a9190610f4b565b925050819055508060045f8282546107729190610f4b565b925050819055505050565b5f60055f8373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020015f20549050919050565b600180546107d090610eee565b80601f01602080910402602001604051908101604052809291908181526020018280546107fc90610eee565b80156108475780601f1061081e57610100808354040283529160200191610847565b820191905f5260205f20905b81548152906001019060200180831161082a57829003601f168201915b505050505081565b5f8160055f3373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020015f205f82825461089c9190610f4b565b925050819055508160055f8573ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020015f205f8282546108ef9190610f7e565b925050819055506001905092915050565b61090a338261067f565b3373ffffffffffffffffffffffffffffffffffffffff167fe1fffcc4923d04b559f4d29a8bfc6cda04eb5b0d3c460751c2402c5c5cc9109c826040516109509190610c51565b60405180910390a250565b5f60065f8473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020015f205f8373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020015f2054905092915050565b600280546109ea90610eee565b80601f0160208091040260200160405190810160405280929190818152602001828054610a1690610eee565b8015610a615780601f10610a3857610100808354040283529160200191610a61565b820191905f5260205f20905b815481529060010190602001808311610a4457829003601f168201915b505050505081565b606060405180606001604052806035815260200161100f60359139905090565b5f81519050919050565b5f82825260208201905092915050565b5f5b83811015610ac0578082015181840152602081019050610aa5565b5f8484015250505050565b5f601f19601f8301169050919050565b5f610ae582610a89565b610aef8185610a93565b9350610aff818560208601610aa3565b610b0881610acb565b840191505092915050565b5f6020820190508181035f830152610b2b8184610adb565b905092915050565b5f604051905090565b5f80fd5b5f80fd5b5f73ffffffffffffffffffffffffffffffffffffffff82169050919050565b5f610b6d82610b44565b9050919050565b610b7d81610b63565b8114610b87575f80fd5b50565b5f81359050610b9881610b74565b92915050565b5f819050919050565b610bb081610b9e565b8114610bba575f80fd5b50565b5f81359050610bcb81610ba7565b92915050565b5f8060408385031215610be757610be6610b3c565b5b5f610bf485828601610b8a565b9250506020610c0585828601610bbd565b9150509250929050565b5f8115159050919050565b610c2381610c0f565b82525050565b5f602082019050610c3c5f830184610c1a565b92915050565b610c4b81610b9e565b82525050565b5f602082019050610c645f830184610c42565b92915050565b5f805f60608486031215610c8157610c80610b3c565b5b5f610c8e86828701610b8a565b9350506020610c9f86828701610b8a565b9250506040610cb086828701610bbd565b9150509250925092565b5f60208284031215610ccf57610cce610b3c565b5b5f610cdc84828501610b8a565b91505092915050565b5f60208284031215610cfa57610cf9610b3c565b5b5f610d0784828501610bbd565b91505092915050565b5f80fd5b5f80fd5b7f4e487b71000000000000000000000000000000000000000000000000000000005f52604160045260245ffd5b610d4e82610acb565b810181811067ffffffffffffffff82111715610d6d57610d6c610d18565b5b80604052505050565b5f610d7f610b33565b9050610d8b8282610d45565b919050565b5f67ffffffffffffffff821115610daa57610da9610d18565b5b610db382610acb565b9050602081019050919050565b828183375f83830152505050565b5f610de0610ddb84610d90565b610d76565b905082815260208101848484011115610dfc57610dfb610d14565b5b610e07848285610dc0565b509392505050565b5f82601f830112610e2357610e22610d10565b5b8135610e33848260208601610dce565b91505092915050565b5f60208284031215610e5157610e50610b3c565b5b5f82013567ffffffffffffffff811115610e6e57610e6d610b40565b5b610e7a84828501610e0f565b91505092915050565b5f8060408385031215610e9957610e98610b3c565b5b5f610ea685828601610b8a565b9250506020610eb785828601610b8a565b9150509250929050565b7f4e487b71000000000000000000000000000000000000000000000000000000005f52602260045260245ffd5b5f6002820490506001821680610f0557607f821691505b602082108103610f1857610f17610ec1565b5b50919050565b7f4e487b71000000000000000000000000000000000000000000000000000000005f52601160045260245ffd5b5f610f5582610b9e565b9150610f6083610b9e565b9250828203905081811115610f7857610f77610f1e565b5b92915050565b5f610f8882610b9e565b9150610f9383610b9e565b9250828201905080821115610fab57610faa610f1e565b5b92915050565b5f81905092915050565b5f610fc582610a89565b610fcf8185610fb1565b9350610fdf818560208601610aa3565b80840191505092915050565b5f610ff68285610fbb565b91506110028284610fbb565b9150819050939250505056fe68747470733a2f2f6372696d736f6e2d67656e65726f75732d616e742d3339352e6d7970696e6174612e636c6f75642f697066732fa2646970667358221220689dd34c27994a6691b4d989cd841abc3e79faa708c1cefcdbd7e423bc0804fc64736f6c6343000814003368747470733a2f2f6372696d736f6e2d67656e65726f75732d616e742d3339352e6d7970696e6174612e636c6f75642f697066732f6080604052601260035534801562000015575f80fd5b50604051620018c1380380620018c183398181016040528101906200003b919062000346565b835f90816200004b919062000640565b5082600190816200005d919062000640565b506200006f81620000b960201b60201c565b600290816200007f919062000640565b50620000af33600354600a620000969190620008a1565b84620000a39190620008f1565b620000f560201b60201c565b50505050620009dc565b6060620000cb6200016860201b60201c565b82604051602001620000df9291906200097b565b6040516020818303038152906040529050919050565b8060055f8473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020015f205f828254620001439190620009a2565b925050819055508060045f8282546200015d9190620009a2565b925050819055505050565b60606040518060600160405280603581526020016200188c60359139905090565b5f604051905090565b5f80fd5b5f80fd5b5f80fd5b5f80fd5b5f601f19601f8301169050919050565b7f4e487b71000000000000000000000000000000000000000000000000000000005f52604160045260245ffd5b620001ea82620001a2565b810181811067ffffffffffffffff821117156200020c576200020b620001b2565b5b80604052505050565b5f6200022062000189565b90506200022e8282620001df565b919050565b5f67ffffffffffffffff82111562000250576200024f620001b2565b5b6200025b82620001a2565b9050602081019050919050565b5f5b83811015620002875780820151818401526020810190506200026a565b5f8484015250505050565b5f620002a8620002a28462000233565b62000215565b905082815260208101848484011115620002c757620002c66200019e565b5b620002d484828562000268565b509392505050565b5f82601f830112620002f357620002f26200019a565b5b81516200030584826020860162000292565b91505092915050565b5f819050919050565b62000322816200030e565b81146200032d575f80fd5b50565b5f81519050620003408162000317565b92915050565b5f805f806080858703121562000361576200036062000192565b5b5f85015167ffffffffffffffff81111562000381576200038062000196565b5b6200038f87828801620002dc565b945050602085015167ffffffffffffffff811115620003b357620003b262000196565b5b620003c187828801620002dc565b9350506040620003d48782880162000330565b925050606085015167ffffffffffffffff811115620003f857620003f762000196565b5b6200040687828801620002dc565b91505092959194509250565b5f81519050919050565b7f4e487b71000000000000000000000000000000000000000000000000000000005f52602260045260245ffd5b5f60028204905060018216806200046157607f821691505b6020821081036200047757620004766200041c565b5b50919050565b5f819050815f5260205f209050919050565b5f6020601f8301049050919050565b5f82821b905092915050565b5f60088302620004db7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff826200049e565b620004e786836200049e565b95508019841693508086168417925050509392505050565b5f819050919050565b5f62000528620005226200051c846200030e565b620004ff565b6200030e565b9050919050565b5f819050919050565b620005438362000508565b6200055b62000552826200052f565b848454620004aa565b825550505050565b5f90565b6200057162000563565b6200057e81848462000538565b505050565b5b81811015620005a557620005995f8262000567565b60018101905062000584565b5050565b601f821115620005f457620005be816200047d565b620005c9846200048f565b81016020851015620005d9578190505b620005f1620005e8856200048f565b83018262000583565b50505b505050565b5f82821c905092915050565b5f620006165f1984600802620005f9565b1980831691505092915050565b5f62000630838362000605565b9150826002028217905092915050565b6200064b8262000412565b67ffffffffffffffff811115620006675762000666620001b2565b5b62000673825462000449565b62000680828285620005a9565b5f60209050601f831160018114620006b6575f8415620006a1578287015190505b620006ad858262000623565b8655506200071c565b601f198416620006c6866200047d565b5f5b82811015620006ef57848901518255600182019150602085019450602081019050620006c8565b868310156200070f57848901516200070b601f89168262000605565b8355505b6001600288020188555050505b505050505050565b7f4e487b71000000000000000000000000000000000000000000000000000000005f52601160045260245ffd5b5f8160011c9050919050565b5f808291508390505b6001851115620007ae5780860481111562000786576200078562000724565b5b6001851615620007965780820291505b8081029050620007a68562000751565b945062000766565b94509492505050565b5f82620007c857600190506200089a565b81620007d7575f90506200089a565b8160018114620007f05760028114620007fb5762000831565b60019150506200089a565b60ff84111562000810576200080f62000724565b5b8360020a9150848211156200082a576200082962000724565b5b506200089a565b5060208310610133831016604e8410600b84101617156200086b5782820a90508381111562000865576200086462000724565b5b6200089a565b6200087a84848460016200075d565b9250905081840481111562000894576200089362000724565b5b81810290505b9392505050565b5f620008ad826200030e565b9150620008ba836200030e565b9250620008e97fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff8484620007b7565b905092915050565b5f620008fd826200030e565b91506200090a836200030e565b92508282026200091a816200030e565b9150828204841483151762000934576200093362000724565b5b5092915050565b5f81905092915050565b5f620009518262000412565b6200095d81856200093b565b93506200096f81856020860162000268565b80840191505092915050565b5f62000988828562000945565b915062000996828462000945565b91508190509392505050565b5f620009ae826200030e565b9150620009bb836200030e565b9250828201905080821115620009d657620009d562000724565b5b92915050565b610ea280620009ea5f395ff3fe608060405234801561000f575f80fd5b50600436106100e8575f3560e01c806355b6ed5c1161008a57806395d89b411161006457806395d89b4114610280578063a9059cbb1461029e578063dd62ed3e146102ce578063eac989f8146102fe576100e8565b806355b6ed5c146102045780636161eb181461023457806370a0823114610250576100e8565b806323b872dd116100c657806323b872dd1461015857806327e235e3146101885780634cf12d26146101b85780634e6ec247146101e8576100e8565b806306fdde03146100ec578063095ea7b31461010a57806318160ddd1461013a575b5f80fd5b6100f461031c565b6040516101019190610967565b60405180910390f35b610124600480360381019061011f9190610a25565b6103a7565b6040516101319190610a7d565b60405180910390f35b61014261042f565b60405161014f9190610aa5565b60405180910390f35b610172600480360381019061016d9190610abe565b610435565b60405161017f9190610a7d565b60405180910390f35b6101a2600480360381019061019d9190610b0e565b6104e7565b6040516101af9190610aa5565b60405180910390f35b6101d260048036038101906101cd9190610c65565b6104fc565b6040516101df9190610967565b60405180910390f35b61020260048036038101906101fd9190610a25565b61052e565b005b61021e60048036038101906102199190610cac565b61059d565b60405161022b9190610aa5565b60405180910390f35b61024e60048036038101906102499190610a25565b6105bd565b005b61026a60048036038101906102659190610b0e565b61062c565b6040516102779190610aa5565b60405180910390f35b610288610672565b6040516102959190610967565b60405180910390f35b6102b860048036038101906102b39190610a25565b6106fe565b6040516102c59190610a7d565b60405180910390f35b6102e860048036038101906102e39190610cac565b6107af565b6040516102f59190610aa5565b60405180910390f35b610306610831565b6040516103139190610967565b60405180910390f35b5f805461032890610d17565b80601f016020809104026020016040519081016040528092919081815260200182805461035490610d17565b801561039f5780601f106103765761010080835404028352916020019161039f565b820191905f5260205f20905b81548152906001019060200180831161038257829003601f168201915b505050505081565b5f8160065f3373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020015f205f8573ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020015f20819055506001905092915050565b60045481565b5f8160055f8673ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020015f205f8282546104829190610d74565b925050819055508160055f8573ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020015f205f8282546104d59190610da7565b92505081905550600190509392505050565b6005602052805f5260405f205f915090505481565b60606105066108bd565b82604051602001610518929190610e14565b6040516020818303038152906040529050919050565b8060055f8473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020015f205f82825461057a9190610da7565b925050819055508060045f8282546105929190610da7565b925050819055505050565b6006602052815f5260405f20602052805f5260405f205f91509150505481565b8060055f8473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020015f205f8282546106099190610d74565b925050819055508060045f8282546106219190610d74565b925050819055505050565b5f60055f8373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020015f20549050919050565b6001805461067f90610d17565b80601f01602080910402602001604051908101604052809291908181526020018280546106ab90610d17565b80156106f65780601f106106cd576101008083540402835291602001916106f6565b820191905f5260205f20905b8154815290600101906020018083116106d957829003601f168201915b505050505081565b5f8160055f3373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020015f205f82825461074b9190610d74565b925050819055508160055f8573ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020015f205f82825461079e9190610da7565b925050819055506001905092915050565b5f60065f8473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020015f205f8373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020015f2054905092915050565b6002805461083e90610d17565b80601f016020809104026020016040519081016040528092919081815260200182805461086a90610d17565b80156108b55780601f1061088c576101008083540402835291602001916108b5565b820191905f5260205f20905b81548152906001019060200180831161089857829003601f168201915b505050505081565b6060604051806060016040528060358152602001610e3860359139905090565b5f81519050919050565b5f82825260208201905092915050565b5f5b838110156109145780820151818401526020810190506108f9565b5f8484015250505050565b5f601f19601f8301169050919050565b5f610939826108dd565b61094381856108e7565b93506109538185602086016108f7565b61095c8161091f565b840191505092915050565b5f6020820190508181035f83015261097f818461092f565b905092915050565b5f604051905090565b5f80fd5b5f80fd5b5f73ffffffffffffffffffffffffffffffffffffffff82169050919050565b5f6109c182610998565b9050919050565b6109d1816109b7565b81146109db575f80fd5b50565b5f813590506109ec816109c8565b92915050565b5f819050919050565b610a04816109f2565b8114610a0e575f80fd5b50565b5f81359050610a1f816109fb565b92915050565b5f8060408385031215610a3b57610a3a610990565b5b5f610a48858286016109de565b9250506020610a5985828601610a11565b9150509250929050565b5f8115159050919050565b610a7781610a63565b82525050565b5f602082019050610a905f830184610a6e565b92915050565b610a9f816109f2565b82525050565b5f602082019050610ab85f830184610a96565b92915050565b5f805f60608486031215610ad557610ad4610990565b5b5f610ae2868287016109de565b9350506020610af3868287016109de565b9250506040610b0486828701610a11565b9150509250925092565b5f60208284031215610b2357610b22610990565b5b5f610b30848285016109de565b91505092915050565b5f80fd5b5f80fd5b7f4e487b71000000000000000000000000000000000000000000000000000000005f52604160045260245ffd5b610b778261091f565b810181811067ffffffffffffffff82111715610b9657610b95610b41565b5b80604052505050565b5f610ba8610987565b9050610bb48282610b6e565b919050565b5f67ffffffffffffffff821115610bd357610bd2610b41565b5b610bdc8261091f565b9050602081019050919050565b828183375f83830152505050565b5f610c09610c0484610bb9565b610b9f565b905082815260208101848484011115610c2557610c24610b3d565b5b610c30848285610be9565b509392505050565b5f82601f830112610c4c57610c4b610b39565b5b8135610c5c848260208601610bf7565b91505092915050565b5f60208284031215610c7a57610c79610990565b5b5f82013567ffffffffffffffff811115610c9757610c96610994565b5b610ca384828501610c38565b91505092915050565b5f8060408385031215610cc257610cc1610990565b5b5f610ccf858286016109de565b9250506020610ce0858286016109de565b9150509250929050565b7f4e487b71000000000000000000000000000000000000000000000000000000005f52602260045260245ffd5b5f6002820490506001821680610d2e57607f821691505b602082108103610d4157610d40610cea565b5b50919050565b7f4e487b71000000000000000000000000000000000000000000000000000000005f52601160045260245ffd5b5f610d7e826109f2565b9150610d89836109f2565b9250828203905081811115610da157610da0610d47565b5b92915050565b5f610db1826109f2565b9150610dbc836109f2565b9250828201905080821115610dd457610dd3610d47565b5b92915050565b5f81905092915050565b5f610dee826108dd565b610df88185610dda565b9350610e088185602086016108f7565b80840191505092915050565b5f610e1f8285610de4565b9150610e2b8284610de4565b9150819050939250505056fe68747470733a2f2f6372696d736f6e2d67656e65726f75732d616e742d3339352e6d7970696e6174612e636c6f75642f697066732fa26469706673582212202c3349112e929b356390259ac4e87c0a84b41e8d0c4b2abd25967e28b77aa16a64736f6c6343000814003368747470733a2f2f6372696d736f6e2d67656e65726f75732d616e742d3339352e6d7970696e6174612e636c6f75642f697066732f";

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
