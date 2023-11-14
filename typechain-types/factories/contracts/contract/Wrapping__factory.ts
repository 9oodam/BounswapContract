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
  Wrapping,
  WrappingInterface,
} from "../../../contracts/contract/Wrapping";

const _abi = [
  {
    inputs: [
      {
        internalType: "address",
        name: "_wbncContract",
        type: "address",
      },
    ],
    stateMutability: "nonpayable",
    type: "constructor",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "userAddress",
        type: "address",
      },
    ],
    name: "depositWBNC",
    outputs: [
      {
        internalType: "bool",
        name: "",
        type: "bool",
      },
    ],
    stateMutability: "payable",
    type: "function",
  },
  {
    inputs: [],
    name: "owner",
    outputs: [
      {
        internalType: "address",
        name: "",
        type: "address",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "wbncContract",
    outputs: [
      {
        internalType: "contract WBNC",
        name: "",
        type: "address",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "userAddress",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "wbncAmount",
        type: "uint256",
      },
    ],
    name: "withdrawWBNC",
    outputs: [
      {
        internalType: "bool",
        name: "",
        type: "bool",
      },
    ],
    stateMutability: "payable",
    type: "function",
  },
] as const;

const _bytecode =
  "0x608060405234801561000f575f80fd5b5060405161072538038061072583398181016040528101906100319190610114565b335f806101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff1602179055508060015f6101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff1602179055505061013f565b5f80fd5b5f73ffffffffffffffffffffffffffffffffffffffff82169050919050565b5f6100e3826100ba565b9050919050565b6100f3816100d9565b81146100fd575f80fd5b50565b5f8151905061010e816100ea565b92915050565b5f60208284031215610129576101286100b6565b5b5f61013684828501610100565b91505092915050565b6105d98061014c5f395ff3fe60806040526004361061003e575f3560e01c806351543b77146100425780638da5cb5b14610072578063bd6e99491461009c578063d1092322146100cc575b5f80fd5b61005c600480360381019061005791906103cb565b6100f6565b6040516100699190610423565b60405180910390f35b34801561007d575f80fd5b5061008661025a565b604051610093919061044b565b60405180910390f35b6100b660048036038101906100b19190610464565b61027d565b6040516100c39190610423565b60405180910390f35b3480156100d7575f80fd5b506100e0610315565b6040516100ed91906104ea565b60405180910390f35b5f805f9054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff163373ffffffffffffffffffffffffffffffffffffffff1614610185576040517f08c379a000000000000000000000000000000000000000000000000000000000815260040161017c9061055d565b60405180910390fd5b60015f9054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16632e1a7d4d836040518263ffffffff1660e01b81526004016101df919061058a565b5f604051808303815f87803b1580156101f6575f80fd5b505af1158015610208573d5f803e3d5ffd5b505050508273ffffffffffffffffffffffffffffffffffffffff166108fc8390811502906040515f60405180830381858888f1935050505015801561024f573d5f803e3d5ffd5b506001905092915050565b5f8054906101000a900473ffffffffffffffffffffffffffffffffffffffff1681565b5f8034905060015f9054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1663b6b55f2582836040518363ffffffff1660e01b81526004016102dd919061058a565b5f604051808303818588803b1580156102f4575f80fd5b505af1158015610306573d5f803e3d5ffd5b50505050506001915050919050565b60015f9054906101000a900473ffffffffffffffffffffffffffffffffffffffff1681565b5f80fd5b5f73ffffffffffffffffffffffffffffffffffffffff82169050919050565b5f6103678261033e565b9050919050565b6103778161035d565b8114610381575f80fd5b50565b5f813590506103928161036e565b92915050565b5f819050919050565b6103aa81610398565b81146103b4575f80fd5b50565b5f813590506103c5816103a1565b92915050565b5f80604083850312156103e1576103e061033a565b5b5f6103ee85828601610384565b92505060206103ff858286016103b7565b9150509250929050565b5f8115159050919050565b61041d81610409565b82525050565b5f6020820190506104365f830184610414565b92915050565b6104458161035d565b82525050565b5f60208201905061045e5f83018461043c565b92915050565b5f602082840312156104795761047861033a565b5b5f61048684828501610384565b91505092915050565b5f819050919050565b5f6104b26104ad6104a88461033e565b61048f565b61033e565b9050919050565b5f6104c382610498565b9050919050565b5f6104d4826104b9565b9050919050565b6104e4816104ca565b82525050565b5f6020820190506104fd5f8301846104db565b92915050565b5f82825260208201905092915050565b7f4f6e6c79206f776e65722063616e2077697468647261770000000000000000005f82015250565b5f610547601783610503565b915061055282610513565b602082019050919050565b5f6020820190508181035f8301526105748161053b565b9050919050565b61058481610398565b82525050565b5f60208201905061059d5f83018461057b565b9291505056fea2646970667358221220a56d418bb60e898da078f6eec430751ba2f3e005ba69f4af6897c7b25245ba3464736f6c63430008140033";

type WrappingConstructorParams =
  | [signer?: Signer]
  | ConstructorParameters<typeof ContractFactory>;

const isSuperArgs = (
  xs: WrappingConstructorParams
): xs is ConstructorParameters<typeof ContractFactory> => xs.length > 1;

export class Wrapping__factory extends ContractFactory {
  constructor(...args: WrappingConstructorParams) {
    if (isSuperArgs(args)) {
      super(...args);
    } else {
      super(_abi, _bytecode, args[0]);
    }
  }

  override getDeployTransaction(
    _wbncContract: AddressLike,
    overrides?: NonPayableOverrides & { from?: string }
  ): Promise<ContractDeployTransaction> {
    return super.getDeployTransaction(_wbncContract, overrides || {});
  }
  override deploy(
    _wbncContract: AddressLike,
    overrides?: NonPayableOverrides & { from?: string }
  ) {
    return super.deploy(_wbncContract, overrides || {}) as Promise<
      Wrapping & {
        deploymentTransaction(): ContractTransactionResponse;
      }
    >;
  }
  override connect(runner: ContractRunner | null): Wrapping__factory {
    return super.connect(runner) as Wrapping__factory;
  }

  static readonly bytecode = _bytecode;
  static readonly abi = _abi;
  static createInterface(): WrappingInterface {
    return new Interface(_abi) as WrappingInterface;
  }
  static connect(address: string, runner?: ContractRunner | null): Wrapping {
    return new Contract(address, _abi, runner) as unknown as Wrapping;
  }
}
