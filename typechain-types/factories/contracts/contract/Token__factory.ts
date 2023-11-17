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
  BigNumberish,
  ContractDeployTransaction,
  ContractRunner,
} from "ethers";
import type { NonPayableOverrides } from "../../../common";
import type { Token, TokenInterface } from "../../../contracts/contract/Token";

const _abi = [
  {
    inputs: [
      {
        internalType: "string",
        name: "_name",
        type: "string",
      },
      {
        internalType: "string",
        name: "_symbol",
        type: "string",
      },
      {
        internalType: "uint256",
        name: "_amount",
        type: "uint256",
      },
      {
        internalType: "string",
        name: "_uri",
        type: "string",
      },
    ],
    stateMutability: "nonpayable",
    type: "constructor",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "address",
        name: "owner",
        type: "address",
      },
      {
        indexed: true,
        internalType: "address",
        name: "spender",
        type: "address",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "value",
        type: "uint256",
      },
    ],
    name: "Approval",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "address",
        name: "from",
        type: "address",
      },
      {
        indexed: true,
        internalType: "address",
        name: "to",
        type: "address",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "value",
        type: "uint256",
      },
    ],
    name: "Transfer",
    type: "event",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "owner",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "amount",
        type: "uint256",
      },
    ],
    name: "_burn",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "to",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "amount",
        type: "uint256",
      },
    ],
    name: "_mint",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "owner",
        type: "address",
      },
      {
        internalType: "address",
        name: "spender",
        type: "address",
      },
    ],
    name: "allowance",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "",
        type: "address",
      },
      {
        internalType: "address",
        name: "",
        type: "address",
      },
    ],
    name: "allowances",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "spender",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "amount",
        type: "uint256",
      },
    ],
    name: "approve",
    outputs: [
      {
        internalType: "bool",
        name: "",
        type: "bool",
      },
    ],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "account",
        type: "address",
      },
    ],
    name: "balanceOf",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "",
        type: "address",
      },
    ],
    name: "balances",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "name",
    outputs: [
      {
        internalType: "string",
        name: "",
        type: "string",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "symbol",
    outputs: [
      {
        internalType: "string",
        name: "",
        type: "string",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "string",
        name: "_imageUri",
        type: "string",
      },
    ],
    name: "tokenURI",
    outputs: [
      {
        internalType: "string",
        name: "",
        type: "string",
      },
    ],
    stateMutability: "pure",
    type: "function",
  },
  {
    inputs: [],
    name: "totalSupply",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "to",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "amount",
        type: "uint256",
      },
    ],
    name: "transfer",
    outputs: [
      {
        internalType: "bool",
        name: "",
        type: "bool",
      },
    ],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "from",
        type: "address",
      },
      {
        internalType: "address",
        name: "to",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "value",
        type: "uint256",
      },
    ],
    name: "transferFrom",
    outputs: [
      {
        internalType: "bool",
        name: "",
        type: "bool",
      },
    ],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [],
    name: "uri",
    outputs: [
      {
        internalType: "string",
        name: "",
        type: "string",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
] as const;

const _bytecode =
  "0x6080604052601260035534801562000015575f80fd5b50604051620018c1380380620018c183398181016040528101906200003b919062000346565b835f90816200004b919062000640565b5082600190816200005d919062000640565b506200006f81620000b960201b60201c565b600290816200007f919062000640565b50620000af33600354600a620000969190620008a1565b84620000a39190620008f1565b620000f560201b60201c565b50505050620009dc565b6060620000cb6200016860201b60201c565b82604051602001620000df9291906200097b565b6040516020818303038152906040529050919050565b8060055f8473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020015f205f828254620001439190620009a2565b925050819055508060045f8282546200015d9190620009a2565b925050819055505050565b60606040518060600160405280603581526020016200188c60359139905090565b5f604051905090565b5f80fd5b5f80fd5b5f80fd5b5f80fd5b5f601f19601f8301169050919050565b7f4e487b71000000000000000000000000000000000000000000000000000000005f52604160045260245ffd5b620001ea82620001a2565b810181811067ffffffffffffffff821117156200020c576200020b620001b2565b5b80604052505050565b5f6200022062000189565b90506200022e8282620001df565b919050565b5f67ffffffffffffffff82111562000250576200024f620001b2565b5b6200025b82620001a2565b9050602081019050919050565b5f5b83811015620002875780820151818401526020810190506200026a565b5f8484015250505050565b5f620002a8620002a28462000233565b62000215565b905082815260208101848484011115620002c757620002c66200019e565b5b620002d484828562000268565b509392505050565b5f82601f830112620002f357620002f26200019a565b5b81516200030584826020860162000292565b91505092915050565b5f819050919050565b62000322816200030e565b81146200032d575f80fd5b50565b5f81519050620003408162000317565b92915050565b5f805f806080858703121562000361576200036062000192565b5b5f85015167ffffffffffffffff81111562000381576200038062000196565b5b6200038f87828801620002dc565b945050602085015167ffffffffffffffff811115620003b357620003b262000196565b5b620003c187828801620002dc565b9350506040620003d48782880162000330565b925050606085015167ffffffffffffffff811115620003f857620003f762000196565b5b6200040687828801620002dc565b91505092959194509250565b5f81519050919050565b7f4e487b71000000000000000000000000000000000000000000000000000000005f52602260045260245ffd5b5f60028204905060018216806200046157607f821691505b6020821081036200047757620004766200041c565b5b50919050565b5f819050815f5260205f209050919050565b5f6020601f8301049050919050565b5f82821b905092915050565b5f60088302620004db7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff826200049e565b620004e786836200049e565b95508019841693508086168417925050509392505050565b5f819050919050565b5f62000528620005226200051c846200030e565b620004ff565b6200030e565b9050919050565b5f819050919050565b620005438362000508565b6200055b62000552826200052f565b848454620004aa565b825550505050565b5f90565b6200057162000563565b6200057e81848462000538565b505050565b5b81811015620005a557620005995f8262000567565b60018101905062000584565b5050565b601f821115620005f457620005be816200047d565b620005c9846200048f565b81016020851015620005d9578190505b620005f1620005e8856200048f565b83018262000583565b50505b505050565b5f82821c905092915050565b5f620006165f1984600802620005f9565b1980831691505092915050565b5f62000630838362000605565b9150826002028217905092915050565b6200064b8262000412565b67ffffffffffffffff811115620006675762000666620001b2565b5b62000673825462000449565b62000680828285620005a9565b5f60209050601f831160018114620006b6575f8415620006a1578287015190505b620006ad858262000623565b8655506200071c565b601f198416620006c6866200047d565b5f5b82811015620006ef57848901518255600182019150602085019450602081019050620006c8565b868310156200070f57848901516200070b601f89168262000605565b8355505b6001600288020188555050505b505050505050565b7f4e487b71000000000000000000000000000000000000000000000000000000005f52601160045260245ffd5b5f8160011c9050919050565b5f808291508390505b6001851115620007ae5780860481111562000786576200078562000724565b5b6001851615620007965780820291505b8081029050620007a68562000751565b945062000766565b94509492505050565b5f82620007c857600190506200089a565b81620007d7575f90506200089a565b8160018114620007f05760028114620007fb5762000831565b60019150506200089a565b60ff84111562000810576200080f62000724565b5b8360020a9150848211156200082a576200082962000724565b5b506200089a565b5060208310610133831016604e8410600b84101617156200086b5782820a90508381111562000865576200086462000724565b5b6200089a565b6200087a84848460016200075d565b9250905081840481111562000894576200089362000724565b5b81810290505b9392505050565b5f620008ad826200030e565b9150620008ba836200030e565b9250620008e97fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff8484620007b7565b905092915050565b5f620008fd826200030e565b91506200090a836200030e565b92508282026200091a816200030e565b9150828204841483151762000934576200093362000724565b5b5092915050565b5f81905092915050565b5f620009518262000412565b6200095d81856200093b565b93506200096f81856020860162000268565b80840191505092915050565b5f62000988828562000945565b915062000996828462000945565b91508190509392505050565b5f620009ae826200030e565b9150620009bb836200030e565b9250828201905080821115620009d657620009d562000724565b5b92915050565b610ea280620009ea5f395ff3fe608060405234801561000f575f80fd5b50600436106100e8575f3560e01c806355b6ed5c1161008a57806395d89b411161006457806395d89b4114610280578063a9059cbb1461029e578063dd62ed3e146102ce578063eac989f8146102fe576100e8565b806355b6ed5c146102045780636161eb181461023457806370a0823114610250576100e8565b806323b872dd116100c657806323b872dd1461015857806327e235e3146101885780634cf12d26146101b85780634e6ec247146101e8576100e8565b806306fdde03146100ec578063095ea7b31461010a57806318160ddd1461013a575b5f80fd5b6100f461031c565b6040516101019190610967565b60405180910390f35b610124600480360381019061011f9190610a25565b6103a7565b6040516101319190610a7d565b60405180910390f35b61014261042f565b60405161014f9190610aa5565b60405180910390f35b610172600480360381019061016d9190610abe565b610435565b60405161017f9190610a7d565b60405180910390f35b6101a2600480360381019061019d9190610b0e565b6104e7565b6040516101af9190610aa5565b60405180910390f35b6101d260048036038101906101cd9190610c65565b6104fc565b6040516101df9190610967565b60405180910390f35b61020260048036038101906101fd9190610a25565b61052e565b005b61021e60048036038101906102199190610cac565b61059d565b60405161022b9190610aa5565b60405180910390f35b61024e60048036038101906102499190610a25565b6105bd565b005b61026a60048036038101906102659190610b0e565b61062c565b6040516102779190610aa5565b60405180910390f35b610288610672565b6040516102959190610967565b60405180910390f35b6102b860048036038101906102b39190610a25565b6106fe565b6040516102c59190610a7d565b60405180910390f35b6102e860048036038101906102e39190610cac565b6107af565b6040516102f59190610aa5565b60405180910390f35b610306610831565b6040516103139190610967565b60405180910390f35b5f805461032890610d17565b80601f016020809104026020016040519081016040528092919081815260200182805461035490610d17565b801561039f5780601f106103765761010080835404028352916020019161039f565b820191905f5260205f20905b81548152906001019060200180831161038257829003601f168201915b505050505081565b5f8160065f3373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020015f205f8573ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020015f20819055506001905092915050565b60045481565b5f8160055f8673ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020015f205f8282546104829190610d74565b925050819055508160055f8573ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020015f205f8282546104d59190610da7565b92505081905550600190509392505050565b6005602052805f5260405f205f915090505481565b60606105066108bd565b82604051602001610518929190610e14565b6040516020818303038152906040529050919050565b8060055f8473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020015f205f82825461057a9190610da7565b925050819055508060045f8282546105929190610da7565b925050819055505050565b6006602052815f5260405f20602052805f5260405f205f91509150505481565b8060055f8473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020015f205f8282546106099190610d74565b925050819055508060045f8282546106219190610d74565b925050819055505050565b5f60055f8373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020015f20549050919050565b6001805461067f90610d17565b80601f01602080910402602001604051908101604052809291908181526020018280546106ab90610d17565b80156106f65780601f106106cd576101008083540402835291602001916106f6565b820191905f5260205f20905b8154815290600101906020018083116106d957829003601f168201915b505050505081565b5f8160055f3373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020015f205f82825461074b9190610d74565b925050819055508160055f8573ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020015f205f82825461079e9190610da7565b925050819055506001905092915050565b5f60065f8473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020015f205f8373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020015f2054905092915050565b6002805461083e90610d17565b80601f016020809104026020016040519081016040528092919081815260200182805461086a90610d17565b80156108b55780601f1061088c576101008083540402835291602001916108b5565b820191905f5260205f20905b81548152906001019060200180831161089857829003601f168201915b505050505081565b6060604051806060016040528060358152602001610e3860359139905090565b5f81519050919050565b5f82825260208201905092915050565b5f5b838110156109145780820151818401526020810190506108f9565b5f8484015250505050565b5f601f19601f8301169050919050565b5f610939826108dd565b61094381856108e7565b93506109538185602086016108f7565b61095c8161091f565b840191505092915050565b5f6020820190508181035f83015261097f818461092f565b905092915050565b5f604051905090565b5f80fd5b5f80fd5b5f73ffffffffffffffffffffffffffffffffffffffff82169050919050565b5f6109c182610998565b9050919050565b6109d1816109b7565b81146109db575f80fd5b50565b5f813590506109ec816109c8565b92915050565b5f819050919050565b610a04816109f2565b8114610a0e575f80fd5b50565b5f81359050610a1f816109fb565b92915050565b5f8060408385031215610a3b57610a3a610990565b5b5f610a48858286016109de565b9250506020610a5985828601610a11565b9150509250929050565b5f8115159050919050565b610a7781610a63565b82525050565b5f602082019050610a905f830184610a6e565b92915050565b610a9f816109f2565b82525050565b5f602082019050610ab85f830184610a96565b92915050565b5f805f60608486031215610ad557610ad4610990565b5b5f610ae2868287016109de565b9350506020610af3868287016109de565b9250506040610b0486828701610a11565b9150509250925092565b5f60208284031215610b2357610b22610990565b5b5f610b30848285016109de565b91505092915050565b5f80fd5b5f80fd5b7f4e487b71000000000000000000000000000000000000000000000000000000005f52604160045260245ffd5b610b778261091f565b810181811067ffffffffffffffff82111715610b9657610b95610b41565b5b80604052505050565b5f610ba8610987565b9050610bb48282610b6e565b919050565b5f67ffffffffffffffff821115610bd357610bd2610b41565b5b610bdc8261091f565b9050602081019050919050565b828183375f83830152505050565b5f610c09610c0484610bb9565b610b9f565b905082815260208101848484011115610c2557610c24610b3d565b5b610c30848285610be9565b509392505050565b5f82601f830112610c4c57610c4b610b39565b5b8135610c5c848260208601610bf7565b91505092915050565b5f60208284031215610c7a57610c79610990565b5b5f82013567ffffffffffffffff811115610c9757610c96610994565b5b610ca384828501610c38565b91505092915050565b5f8060408385031215610cc257610cc1610990565b5b5f610ccf858286016109de565b9250506020610ce0858286016109de565b9150509250929050565b7f4e487b71000000000000000000000000000000000000000000000000000000005f52602260045260245ffd5b5f6002820490506001821680610d2e57607f821691505b602082108103610d4157610d40610cea565b5b50919050565b7f4e487b71000000000000000000000000000000000000000000000000000000005f52601160045260245ffd5b5f610d7e826109f2565b9150610d89836109f2565b9250828203905081811115610da157610da0610d47565b5b92915050565b5f610db1826109f2565b9150610dbc836109f2565b9250828201905080821115610dd457610dd3610d47565b5b92915050565b5f81905092915050565b5f610dee826108dd565b610df88185610dda565b9350610e088185602086016108f7565b80840191505092915050565b5f610e1f8285610de4565b9150610e2b8284610de4565b9150819050939250505056fe68747470733a2f2f6372696d736f6e2d67656e65726f75732d616e742d3339352e6d7970696e6174612e636c6f75642f697066732fa26469706673582212202c3349112e929b356390259ac4e87c0a84b41e8d0c4b2abd25967e28b77aa16a64736f6c6343000814003368747470733a2f2f6372696d736f6e2d67656e65726f75732d616e742d3339352e6d7970696e6174612e636c6f75642f697066732f";

type TokenConstructorParams =
  | [signer?: Signer]
  | ConstructorParameters<typeof ContractFactory>;

const isSuperArgs = (
  xs: TokenConstructorParams
): xs is ConstructorParameters<typeof ContractFactory> => xs.length > 1;

export class Token__factory extends ContractFactory {
  constructor(...args: TokenConstructorParams) {
    if (isSuperArgs(args)) {
      super(...args);
    } else {
      super(_abi, _bytecode, args[0]);
    }
  }

  override getDeployTransaction(
    _name: string,
    _symbol: string,
    _amount: BigNumberish,
    _uri: string,
    overrides?: NonPayableOverrides & { from?: string }
  ): Promise<ContractDeployTransaction> {
    return super.getDeployTransaction(
      _name,
      _symbol,
      _amount,
      _uri,
      overrides || {}
    );
  }
  override deploy(
    _name: string,
    _symbol: string,
    _amount: BigNumberish,
    _uri: string,
    overrides?: NonPayableOverrides & { from?: string }
  ) {
    return super.deploy(
      _name,
      _symbol,
      _amount,
      _uri,
      overrides || {}
    ) as Promise<
      Token & {
        deploymentTransaction(): ContractTransactionResponse;
      }
    >;
  }
  override connect(runner: ContractRunner | null): Token__factory {
    return super.connect(runner) as Token__factory;
  }

  static readonly bytecode = _bytecode;
  static readonly abi = _abi;
  static createInterface(): TokenInterface {
    return new Interface(_abi) as TokenInterface;
  }
  static connect(address: string, runner?: ContractRunner | null): Token {
    return new Contract(address, _abi, runner) as unknown as Token;
  }
}
