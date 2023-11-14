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
import type { Swap, SwapInterface } from "../../../contracts/contract/Swap";

const _abi = [
  {
    inputs: [
      {
        internalType: "address",
        name: "_dataAddress",
        type: "address",
      },
      {
        internalType: "address",
        name: "_wbncAddress",
        type: "address",
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
        name: "sender",
        type: "address",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "amount0In",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "amount1In",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "amount0Out",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "amount1Out",
        type: "uint256",
      },
      {
        indexed: true,
        internalType: "address",
        name: "to",
        type: "address",
      },
    ],
    name: "Swap",
    type: "event",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "pairAddress",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "outputAmount",
        type: "uint256",
      },
      {
        internalType: "address[2]",
        name: "path",
        type: "address[2]",
      },
      {
        internalType: "address",
        name: "to",
        type: "address",
      },
    ],
    name: "bNCForExactTokens",
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
    inputs: [
      {
        internalType: "address",
        name: "pairAddress",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "inputAmount",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "minToken",
        type: "uint256",
      },
      {
        internalType: "address[2]",
        name: "path",
        type: "address[2]",
      },
      {
        internalType: "address",
        name: "to",
        type: "address",
      },
    ],
    name: "exactBNCForTokens",
    outputs: [],
    stateMutability: "payable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "pairAddress",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "inputAmount",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "minToken",
        type: "uint256",
      },
      {
        internalType: "address[2]",
        name: "path",
        type: "address[2]",
      },
      {
        internalType: "address",
        name: "to",
        type: "address",
      },
    ],
    name: "exactTokensForBNC",
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
    inputs: [
      {
        internalType: "address",
        name: "pairAddress",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "inputAmount",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "minToken",
        type: "uint256",
      },
      {
        internalType: "address[2]",
        name: "path",
        type: "address[2]",
      },
      {
        internalType: "address",
        name: "to",
        type: "address",
      },
    ],
    name: "exactTokensForTokens",
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
        name: "pairAddress",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "outputAmount",
        type: "uint256",
      },
      {
        internalType: "address[2]",
        name: "path",
        type: "address[2]",
      },
    ],
    name: "getAmountIn",
    outputs: [
      {
        internalType: "uint256",
        name: "amountIn",
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
        name: "pairAddress",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "inputAmount",
        type: "uint256",
      },
      {
        internalType: "address[2]",
        name: "path",
        type: "address[2]",
      },
    ],
    name: "getAmountOut",
    outputs: [
      {
        internalType: "uint256",
        name: "amountOut",
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
        name: "pairAddress",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "outputAmount",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "maxToken",
        type: "uint256",
      },
      {
        internalType: "address[2]",
        name: "path",
        type: "address[2]",
      },
      {
        internalType: "address",
        name: "to",
        type: "address",
      },
    ],
    name: "tokensForExactBNC",
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
        name: "pairAddress",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "outputAmount",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "maxToken",
        type: "uint256",
      },
      {
        internalType: "address[2]",
        name: "path",
        type: "address[2]",
      },
      {
        internalType: "address",
        name: "to",
        type: "address",
      },
    ],
    name: "tokensForExactTokens",
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
] as const;

const _bytecode =
  "0x6080604052600160035534801562000015575f80fd5b5060405162002ead38038062002ead83398181016040528101906200003b919062000167565b815f806101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff1602179055508060015f6101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff1602179055508060025f6101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff1602179055505050620001ac565b5f80fd5b5f73ffffffffffffffffffffffffffffffffffffffff82169050919050565b5f620001318262000106565b9050919050565b620001438162000125565b81146200014e575f80fd5b50565b5f81519050620001618162000138565b92915050565b5f806040838503121562000180576200017f62000102565b5b5f6200018f8582860162000151565b9250506020620001a28582860162000151565b9150509250929050565b612cf380620001ba5f395ff3fe60806040526004361061007a575f3560e01c8063a49056101161004d578063a49056101461014e578063d5083e641461017e578063e2541aae146101ae578063ef30c11c146101ea5761007a565b806345d17e931461007e5780635d6854a3146100ba5780636e17ad30146100f65780638c4898a914610132575b5f80fd5b348015610089575f80fd5b506100a4600480360381019061009f9190612038565b610226565b6040516100b191906120c9565b60405180910390f35b3480156100c5575f80fd5b506100e060048036038101906100db9190612038565b6103a2565b6040516100ed91906120c9565b60405180910390f35b348015610101575f80fd5b5061011c6004803603810190610117919061221c565b6106ff565b604051610129919061227b565b60405180910390f35b61014c60048036038101906101479190612038565b6108f9565b005b61016860048036038101906101639190612038565b610bb1565b60405161017591906120c9565b60405180910390f35b61019860048036038101906101939190612294565b610f0e565b6040516101a591906120c9565b60405180910390f35b3480156101b9575f80fd5b506101d460048036038101906101cf919061221c565b611242565b6040516101e1919061227b565b60405180910390f35b3480156101f5575f80fd5b50610210600480360381019061020b9190612038565b611490565b60405161021d91906120c9565b60405180910390f35b5f8061026987878660028060200260405190810160405280929190826002602002808284375f81840152601f19601f820116905080830192505050505050611242565b9050848111156102ae576040517f08c379a00000000000000000000000000000000000000000000000000000000081526004016102a590612352565b60405180910390fd5b835f600281106102c1576102c0612370565b5b6020020160208101906102d4919061239d565b73ffffffffffffffffffffffffffffffffffffffff166323b872dd8489846040518463ffffffff1660e01b8152600401610310939291906123d7565b6020604051808303815f875af115801561032c573d5f803e3d5ffd5b505050506040513d601f19601f820116820180604052508101906103509190612436565b506103948388888760028060200260405190810160405280929190826002602002808284375f81840152601f19601f8201169050808301925050505050508761160c565b600191505095945050505050565b5f60025f9054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16836001600281106103ef576103ee612370565b5b602002016020810190610402919061239d565b73ffffffffffffffffffffffffffffffffffffffff1614610458576040517f08c379a000000000000000000000000000000000000000000000000000000000815260040161044f906124ab565b60405180910390fd5b5f61049a87878660028060200260405190810160405280929190826002602002808284375f81840152601f19601f820116905080830192505050505050611242565b9050848111156104df576040517f08c379a00000000000000000000000000000000000000000000000000000000081526004016104d690612352565b60405180910390fd5b835f600281106104f2576104f1612370565b5b602002016020810190610505919061239d565b73ffffffffffffffffffffffffffffffffffffffff166323b872dd8489846040518463ffffffff1660e01b8152600401610541939291906123d7565b6020604051808303815f875af115801561055d573d5f803e3d5ffd5b505050506040513d601f19601f820116820180604052508101906105819190612436565b506105c58388888760028060200260405190810160405280929190826002602002808284375f81840152601f19601f8201169050808301925050505050503061160c565b60015f9054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16632e1a7d4d876040518263ffffffff1660e01b815260040161061f919061227b565b5f604051808303815f87803b158015610636575f80fd5b505af1158015610648573d5f803e3d5ffd5b505050505f8373ffffffffffffffffffffffffffffffffffffffff1687604051610671906124f6565b5f6040518083038185875af1925050503d805f81146106ab576040519150601f19603f3d011682016040523d82523d5f602084013e6106b0565b606091505b50509050806106f4576040517f08c379a00000000000000000000000000000000000000000000000000000000081526004016106eb9061257a565b60405180910390fd5b505095945050505050565b5f808311610742576040517f08c379a000000000000000000000000000000000000000000000000000000000815260040161073990612352565b60405180910390fd5b5f8490505f808273ffffffffffffffffffffffffffffffffffffffff16630902f1ac6040518163ffffffff1660e01b8152600401606060405180830381865afa158015610791573d5f803e3d5ffd5b505050506040513d601f19601f820116820180604052508101906107b59190612614565b506dffffffffffffffffffffffffffff1691506dffffffffffffffffffffffffffff1691505f80865f600281106107ef576107ee612370565b5b602002015173ffffffffffffffffffffffffffffffffffffffff168573ffffffffffffffffffffffffffffffffffffffff16630dfe16816040518163ffffffff1660e01b8152600401602060405180830381865afa158015610853573d5f803e3d5ffd5b505050506040513d601f19601f820116820180604052508101906108779190612678565b73ffffffffffffffffffffffffffffffffffffffff161461089957828461089c565b83835b915091505f6103e5896108af91906126d0565b90505f82826108be91906126d0565b90505f826103e8866108d091906126d0565b6108da9190612711565b905080826108e89190612771565b985050505050505050509392505050565b60025f9054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16825f6002811061094457610943612370565b5b602002016020810190610957919061239d565b73ffffffffffffffffffffffffffffffffffffffff16146109ad576040517f08c379a00000000000000000000000000000000000000000000000000000000081526004016109a4906124ab565b60405180910390fd5b5f6109ef86868560028060200260405190810160405280929190826002602002808284375f81840152601f19601f8201169050808301925050505050506106ff565b905083811015610a34576040517f08c379a0000000000000000000000000000000000000000000000000000000008152600401610a2b906127eb565b60405180910390fd5b60015f9054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1663b6b55f2586876040518363ffffffff1660e01b8152600401610a8f919061227b565b5f604051808303818588803b158015610aa6575f80fd5b505af1158015610ab8573d5f803e3d5ffd5b505050505060015f9054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1663a9059cbb87876040518363ffffffff1660e01b8152600401610b19929190612809565b6020604051808303815f875af1158015610b35573d5f803e3d5ffd5b505050506040513d601f19601f82011682018060405250810190610b599190612436565b610b6657610b65612830565b5b610ba98287838660028060200260405190810160405280929190826002602002808284375f81840152601f19601f8201169050808301925050505050508661160c565b505050505050565b5f60025f9054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1683600160028110610bfe57610bfd612370565b5b602002016020810190610c11919061239d565b73ffffffffffffffffffffffffffffffffffffffff1614610c67576040517f08c379a0000000000000000000000000000000000000000000000000000000008152600401610c5e906124ab565b60405180910390fd5b5f610ca987878660028060200260405190810160405280929190826002602002808284375f81840152601f19601f8201169050808301925050505050506106ff565b905084811015610cee576040517f08c379a0000000000000000000000000000000000000000000000000000000008152600401610ce5906127eb565b60405180910390fd5b835f60028110610d0157610d00612370565b5b602002016020810190610d14919061239d565b73ffffffffffffffffffffffffffffffffffffffff166323b872dd8489896040518463ffffffff1660e01b8152600401610d50939291906123d7565b6020604051808303815f875af1158015610d6c573d5f803e3d5ffd5b505050506040513d601f19601f82011682018060405250810190610d909190612436565b50610dd48388838760028060200260405190810160405280929190826002602002808284375f81840152601f19601f8201169050808301925050505050503061160c565b60015f9054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16632e1a7d4d826040518263ffffffff1660e01b8152600401610e2e919061227b565b5f604051808303815f87803b158015610e45575f80fd5b505af1158015610e57573d5f803e3d5ffd5b505050505f8373ffffffffffffffffffffffffffffffffffffffff1682604051610e80906124f6565b5f6040518083038185875af1925050503d805f8114610eba576040519150601f19603f3d011682016040523d82523d5f602084013e610ebf565b606091505b5050905080610f03576040517f08c379a0000000000000000000000000000000000000000000000000000000008152600401610efa9061257a565b60405180910390fd5b505095945050505050565b5f60025f9054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16835f60028110610f5a57610f59612370565b5b602002016020810190610f6d919061239d565b73ffffffffffffffffffffffffffffffffffffffff1614610fc3576040517f08c379a0000000000000000000000000000000000000000000000000000000008152600401610fba906124ab565b60405180910390fd5b5f61100586868660028060200260405190810160405280929190826002602002808284375f81840152601f19601f820116905080830192505050505050611242565b90503481111561104a576040517f08c379a0000000000000000000000000000000000000000000000000000000008152600401611041906128a7565b60405180910390fd5b60015f9054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1663b6b55f2582836040518363ffffffff1660e01b81526004016110a5919061227b565b5f604051808303818588803b1580156110bc575f80fd5b505af11580156110ce573d5f803e3d5ffd5b505050505060015f9054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1663a9059cbb87836040518363ffffffff1660e01b815260040161112f929190612809565b6020604051808303815f875af115801561114b573d5f803e3d5ffd5b505050506040513d601f19601f8201168201806040525081019061116f9190612436565b61117c5761117b612830565b5b6111bf8387878760028060200260405190810160405280929190826002602002808284375f81840152601f19601f8201169050808301925050505050508761160c565b80341115611239578273ffffffffffffffffffffffffffffffffffffffff1681346111ea91906128c5565b6040516111f6906124f6565b5f6040518083038185875af1925050503d805f8114611230576040519150601f19603f3d011682016040523d82523d5f602084013e611235565b606091505b5050505b50949350505050565b5f808311611285576040517f08c379a000000000000000000000000000000000000000000000000000000000815260040161127c906127eb565b60405180910390fd5b5f8490505f808273ffffffffffffffffffffffffffffffffffffffff16630902f1ac6040518163ffffffff1660e01b8152600401606060405180830381865afa1580156112d4573d5f803e3d5ffd5b505050506040513d601f19601f820116820180604052508101906112f89190612614565b506dffffffffffffffffffffffffffff1691506dffffffffffffffffffffffffffff1691505f80865f6002811061133257611331612370565b5b602002015173ffffffffffffffffffffffffffffffffffffffff168573ffffffffffffffffffffffffffffffffffffffff16630dfe16816040518163ffffffff1660e01b8152600401602060405180830381865afa158015611396573d5f803e3d5ffd5b505050506040513d601f19601f820116820180604052508101906113ba9190612678565b73ffffffffffffffffffffffffffffffffffffffff16146113dc5782846113df565b83835b915091505f821180156113f157505f81115b611430576040517f08c379a000000000000000000000000000000000000000000000000000000000815260040161142790612942565b60405180910390fd5b5f6103e8898461144091906126d0565b61144a91906126d0565b90505f6103e58a8461145c91906128c5565b61146691906126d0565b9050600181836114769190612771565b6114809190612711565b9750505050505050509392505050565b5f806114d387878660028060200260405190810160405280929190826002602002808284375f81840152601f19601f8201169050808301925050505050506106ff565b905084811015611518576040517f08c379a000000000000000000000000000000000000000000000000000000000815260040161150f906127eb565b60405180910390fd5b835f6002811061152b5761152a612370565b5b60200201602081019061153e919061239d565b73ffffffffffffffffffffffffffffffffffffffff166323b872dd8489896040518463ffffffff1660e01b815260040161157a939291906123d7565b6020604051808303815f875af1158015611596573d5f803e3d5ffd5b505050506040513d601f19601f820116820180604052508101906115ba9190612436565b506115fe8388838760028060200260405190810160405280929190826002602002808284375f81840152601f19601f8201169050808301925050505050508761160c565b600191505095945050505050565b5f80835f6002811061162157611620612370565b5b60200201518460016002811061163a57611639612370565b5b6020020151915091505f808273ffffffffffffffffffffffffffffffffffffffff168473ffffffffffffffffffffffffffffffffffffffff161061167f578284611682565b83835b915091505f808373ffffffffffffffffffffffffffffffffffffffff168673ffffffffffffffffffffffffffffffffffffffff16146116c257885f6116c5565b5f895b915091506116d68b8b84848b6116e3565b5050505050505050505050565b600160035414611728576040517f08c379a000000000000000000000000000000000000000000000000000000000815260040161171f906129aa565b60405180910390fd5b5f6003819055505f83118061173c57505f82115b61177b576040517f08c379a0000000000000000000000000000000000000000000000000000000008152600401611772906127eb565b60405180910390fd5b5f8490505f808273ffffffffffffffffffffffffffffffffffffffff16630902f1ac6040518163ffffffff1660e01b8152600401606060405180830381865afa1580156117ca573d5f803e3d5ffd5b505050506040513d601f19601f820116820180604052508101906117ee9190612614565b5091509150816dffffffffffffffffffffffffffff16861080156118215750806dffffffffffffffffffffffffffff1685105b611860576040517f08c379a000000000000000000000000000000000000000000000000000000000815260040161185790612a12565b60405180910390fd5b5f805f8573ffffffffffffffffffffffffffffffffffffffff16630dfe16816040518163ffffffff1660e01b8152600401602060405180830381865afa1580156118ac573d5f803e3d5ffd5b505050506040513d601f19601f820116820180604052508101906118d09190612678565b90505f8673ffffffffffffffffffffffffffffffffffffffff1663d21220a76040518163ffffffff1660e01b8152600401602060405180830381865afa15801561191c573d5f803e3d5ffd5b505050506040513d601f19601f820116820180604052508101906119409190612678565b90508173ffffffffffffffffffffffffffffffffffffffff168873ffffffffffffffffffffffffffffffffffffffff16141580156119aa57508073ffffffffffffffffffffffffffffffffffffffff168873ffffffffffffffffffffffffffffffffffffffff1614155b6119e9576040517f08c379a00000000000000000000000000000000000000000000000000000000081526004016119e090612a7a565b60405180910390fd5b5f8a1115611a6e578173ffffffffffffffffffffffffffffffffffffffff1663a9059cbb898c6040518363ffffffff1660e01b8152600401611a2c929190612809565b6020604051808303815f875af1158015611a48573d5f803e3d5ffd5b505050506040513d601f19601f82011682018060405250810190611a6c9190612436565b505b5f891115611af3578073ffffffffffffffffffffffffffffffffffffffff1663a9059cbb898b6040518363ffffffff1660e01b8152600401611ab1929190612809565b6020604051808303815f875af1158015611acd573d5f803e3d5ffd5b505050506040513d601f19601f82011682018060405250810190611af19190612436565b505b8173ffffffffffffffffffffffffffffffffffffffff166370a082318c6040518263ffffffff1660e01b8152600401611b2c9190612a98565b602060405180830381865afa158015611b47573d5f803e3d5ffd5b505050506040513d601f19601f82011682018060405250810190611b6b9190612ac5565b93508073ffffffffffffffffffffffffffffffffffffffff166370a082318c6040518263ffffffff1660e01b8152600401611ba69190612a98565b602060405180830381865afa158015611bc1573d5f803e3d5ffd5b505050506040513d601f19601f82011682018060405250810190611be59190612ac5565b925050505f88856dffffffffffffffffffffffffffff16611c0691906128c5565b8311611c12575f611c3a565b88856dffffffffffffffffffffffffffff16611c2e91906128c5565b83611c3991906128c5565b5b90505f88856dffffffffffffffffffffffffffff16611c5991906128c5565b8311611c65575f611c8d565b88856dffffffffffffffffffffffffffff16611c8191906128c5565b83611c8c91906128c5565b5b90505f821180611c9c57505f81115b611cdb576040517f08c379a0000000000000000000000000000000000000000000000000000000008152600401611cd290612352565b60405180910390fd5b5f611cfb611ceb866103e8611e8f565b611cf6856003611e8f565b611f0e565b90505f611d1d611d0d866103e8611e8f565b611d18856003611e8f565b611f0e565b9050611d55611d4c896dffffffffffffffffffffffffffff16896dffffffffffffffffffffffffffff16611e8f565b620f4240611e8f565b611d5f8383611e8f565b1015611da0576040517f08c379a0000000000000000000000000000000000000000000000000000000008152600401611d9790612b3a565b60405180910390fd5b50508673ffffffffffffffffffffffffffffffffffffffff16637dc0a1fa858589896040518563ffffffff1660e01b8152600401611de19493929190612b67565b5f604051808303815f87803b158015611df8575f80fd5b505af1158015611e0a573d5f803e3d5ffd5b505050508a73ffffffffffffffffffffffffffffffffffffffff168c73ffffffffffffffffffffffffffffffffffffffff167fd78ad95fa46c994b6551d0da85fc275fe613ce37657fb8d5e3d130840159d82284848e8e604051611e719493929190612baa565b60405180910390a35050505050505060016003819055505050505050565b5f808284611e9d91906126d0565b90505f831480611ec5575083838486611eb691906126d0565b925082611ec39190612771565b145b611f04576040517f08c379a0000000000000000000000000000000000000000000000000000000008152600401611efb90612c37565b60405180910390fd5b8091505092915050565b5f808284611f1c91906128c5565b9050838385611f2b91906128c5565b9150811115611f6f576040517f08c379a0000000000000000000000000000000000000000000000000000000008152600401611f6690612c9f565b60405180910390fd5b8091505092915050565b5f604051905090565b5f80fd5b5f73ffffffffffffffffffffffffffffffffffffffff82169050919050565b5f611faf82611f86565b9050919050565b611fbf81611fa5565b8114611fc9575f80fd5b50565b5f81359050611fda81611fb6565b92915050565b5f819050919050565b611ff281611fe0565b8114611ffc575f80fd5b50565b5f8135905061200d81611fe9565b92915050565b5f80fd5b5f8190508260206002028201111561203257612031612013565b5b92915050565b5f805f805f60c0868803121561205157612050611f82565b5b5f61205e88828901611fcc565b955050602061206f88828901611fff565b945050604061208088828901611fff565b935050606061209188828901612017565b92505060a06120a288828901611fcc565b9150509295509295909350565b5f8115159050919050565b6120c3816120af565b82525050565b5f6020820190506120dc5f8301846120ba565b92915050565b5f80fd5b5f601f19601f8301169050919050565b7f4e487b71000000000000000000000000000000000000000000000000000000005f52604160045260245ffd5b61212c826120e6565b810181811067ffffffffffffffff8211171561214b5761214a6120f6565b5b80604052505050565b5f61215d611f79565b90506121698282612123565b919050565b5f67ffffffffffffffff821115612188576121876120f6565b5b602082029050919050565b5f6121a56121a08461216e565b612154565b905080602084028301858111156121bf576121be612013565b5b835b818110156121e857806121d48882611fcc565b8452602084019350506020810190506121c1565b5050509392505050565b5f82601f830112612206576122056120e2565b5b6002612213848285612193565b91505092915050565b5f805f6080848603121561223357612232611f82565b5b5f61224086828701611fcc565b935050602061225186828701611fff565b9250506040612262868287016121f2565b9150509250925092565b61227581611fe0565b82525050565b5f60208201905061228e5f83018461226c565b92915050565b5f805f8060a085870312156122ac576122ab611f82565b5b5f6122b987828801611fcc565b94505060206122ca87828801611fff565b93505060406122db87828801612017565b92505060806122ec87828801611fcc565b91505092959194509250565b5f82825260208201905092915050565b7f494e53554646494349454e545f494e5055545f414d4f554e54000000000000005f82015250565b5f61233c6019836122f8565b915061234782612308565b602082019050919050565b5f6020820190508181035f83015261236981612330565b9050919050565b7f4e487b71000000000000000000000000000000000000000000000000000000005f52603260045260245ffd5b5f602082840312156123b2576123b1611f82565b5b5f6123bf84828501611fcc565b91505092915050565b6123d181611fa5565b82525050565b5f6060820190506123ea5f8301866123c8565b6123f760208301856123c8565b612404604083018461226c565b949350505050565b612415816120af565b811461241f575f80fd5b50565b5f815190506124308161240c565b92915050565b5f6020828403121561244b5761244a611f82565b5b5f61245884828501612422565b91505092915050565b7f494e56414c49445f5041544800000000000000000000000000000000000000005f82015250565b5f612495600c836122f8565b91506124a082612461565b602082019050919050565b5f6020820190508181035f8301526124c281612489565b9050919050565b5f81905092915050565b50565b5f6124e15f836124c9565b91506124ec826124d3565b5f82019050919050565b5f612500826124d6565b9150819050919050565b7f5472616e7366657248656c7065723a20455448207472616e73666572206661695f8201527f6c65640000000000000000000000000000000000000000000000000000000000602082015250565b5f6125646023836122f8565b915061256f8261250a565b604082019050919050565b5f6020820190508181035f83015261259181612558565b9050919050565b5f6dffffffffffffffffffffffffffff82169050919050565b6125ba81612598565b81146125c4575f80fd5b50565b5f815190506125d5816125b1565b92915050565b5f63ffffffff82169050919050565b6125f3816125db565b81146125fd575f80fd5b50565b5f8151905061260e816125ea565b92915050565b5f805f6060848603121561262b5761262a611f82565b5b5f612638868287016125c7565b9350506020612649868287016125c7565b925050604061265a86828701612600565b9150509250925092565b5f8151905061267281611fb6565b92915050565b5f6020828403121561268d5761268c611f82565b5b5f61269a84828501612664565b91505092915050565b7f4e487b71000000000000000000000000000000000000000000000000000000005f52601160045260245ffd5b5f6126da82611fe0565b91506126e583611fe0565b92508282026126f381611fe0565b9150828204841483151761270a576127096126a3565b5b5092915050565b5f61271b82611fe0565b915061272683611fe0565b925082820190508082111561273e5761273d6126a3565b5b92915050565b7f4e487b71000000000000000000000000000000000000000000000000000000005f52601260045260245ffd5b5f61277b82611fe0565b915061278683611fe0565b92508261279657612795612744565b5b828204905092915050565b7f494e53554646494349454e545f4f55545055545f414d4f554e540000000000005f82015250565b5f6127d5601a836122f8565b91506127e0826127a1565b602082019050919050565b5f6020820190508181035f830152612802816127c9565b9050919050565b5f60408201905061281c5f8301856123c8565b612829602083018461226c565b9392505050565b7f4e487b71000000000000000000000000000000000000000000000000000000005f52600160045260245ffd5b7f4558434553534956455f494e5055545f414d4f554e54000000000000000000005f82015250565b5f6128916016836122f8565b915061289c8261285d565b602082019050919050565b5f6020820190508181035f8301526128be81612885565b9050919050565b5f6128cf82611fe0565b91506128da83611fe0565b92508282039050818111156128f2576128f16126a3565b5b92915050565b7f494e53554646494349454e54294c4951554944495459000000000000000000005f82015250565b5f61292c6016836122f8565b9150612937826128f8565b602082019050919050565b5f6020820190508181035f83015261295981612920565b9050919050565b7f556e697377617056323a204c4f434b45440000000000000000000000000000005f82015250565b5f6129946011836122f8565b915061299f82612960565b602082019050919050565b5f6020820190508181035f8301526129c181612988565b9050919050565b7f494e53554646494349454e545f4c4951554944495459000000000000000000005f82015250565b5f6129fc6016836122f8565b9150612a07826129c8565b602082019050919050565b5f6020820190508181035f830152612a29816129f0565b9050919050565b7f494e56414c49445f544f000000000000000000000000000000000000000000005f82015250565b5f612a64600a836122f8565b9150612a6f82612a30565b602082019050919050565b5f6020820190508181035f830152612a9181612a58565b9050919050565b5f602082019050612aab5f8301846123c8565b92915050565b5f81519050612abf81611fe9565b92915050565b5f60208284031215612ada57612ad9611f82565b5b5f612ae784828501612ab1565b91505092915050565b7f556e697377617056323a204b00000000000000000000000000000000000000005f82015250565b5f612b24600c836122f8565b9150612b2f82612af0565b602082019050919050565b5f6020820190508181035f830152612b5181612b18565b9050919050565b612b6181612598565b82525050565b5f608082019050612b7a5f83018761226c565b612b87602083018661226c565b612b946040830185612b58565b612ba16060830184612b58565b95945050505050565b5f608082019050612bbd5f83018761226c565b612bca602083018661226c565b612bd7604083018561226c565b612be4606083018461226c565b95945050505050565b7f64732d6d6174682d6d756c2d6f766572666c6f770000000000000000000000005f82015250565b5f612c216014836122f8565b9150612c2c82612bed565b602082019050919050565b5f6020820190508181035f830152612c4e81612c15565b9050919050565b7f64732d6d6174682d7375622d756e646572666c6f7700000000000000000000005f82015250565b5f612c896015836122f8565b9150612c9482612c55565b602082019050919050565b5f6020820190508181035f830152612cb681612c7d565b905091905056fea2646970667358221220515ec73f8c3b2fb58a58e5514789ba8df40cda5dda734403d5ef14b3edffdcf164736f6c63430008140033";

type SwapConstructorParams =
  | [signer?: Signer]
  | ConstructorParameters<typeof ContractFactory>;

const isSuperArgs = (
  xs: SwapConstructorParams
): xs is ConstructorParameters<typeof ContractFactory> => xs.length > 1;

export class Swap__factory extends ContractFactory {
  constructor(...args: SwapConstructorParams) {
    if (isSuperArgs(args)) {
      super(...args);
    } else {
      super(_abi, _bytecode, args[0]);
    }
  }

  override getDeployTransaction(
    _dataAddress: AddressLike,
    _wbncAddress: AddressLike,
    overrides?: NonPayableOverrides & { from?: string }
  ): Promise<ContractDeployTransaction> {
    return super.getDeployTransaction(
      _dataAddress,
      _wbncAddress,
      overrides || {}
    );
  }
  override deploy(
    _dataAddress: AddressLike,
    _wbncAddress: AddressLike,
    overrides?: NonPayableOverrides & { from?: string }
  ) {
    return super.deploy(_dataAddress, _wbncAddress, overrides || {}) as Promise<
      Swap & {
        deploymentTransaction(): ContractTransactionResponse;
      }
    >;
  }
  override connect(runner: ContractRunner | null): Swap__factory {
    return super.connect(runner) as Swap__factory;
  }

  static readonly bytecode = _bytecode;
  static readonly abi = _abi;
  static createInterface(): SwapInterface {
    return new Interface(_abi) as SwapInterface;
  }
  static connect(address: string, runner?: ContractRunner | null): Swap {
    return new Contract(address, _abi, runner) as unknown as Swap;
  }
}
