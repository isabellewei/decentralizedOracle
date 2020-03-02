export const SubmissionAbi = [
    {
      inputs: [
        {
          internalType: 'string',
          name: '_prop1',
          type: 'string'
        },
        {
          internalType: 'string',
          name: '_prop2',
          type: 'string'
        },
        {
          internalType: 'address',
          name: '_submitter',
          type: 'address'
        }
      ],
      payable: false,
      stateMutability: 'nonpayable',
      type: 'constructor'
    },
    {
      constant: true,
      inputs: [
        {
          internalType: 'address',
          name: 'voter',
          type: 'address'
        }
      ],
      name: 'getValidPropNum',
      outputs: [
        {
          internalType: 'uint8',
          name: '',
          type: 'uint8'
        }
      ],
      payable: false,
      stateMutability: 'view',
      type: 'function'
    },
    {
      constant: true,
      inputs: [
        {
          internalType: 'uint8',
          name: 'prop',
          type: 'uint8'
        }
      ],
      name: 'getProp',
      outputs: [
        {
          internalType: 'string',
          name: '',
          type: 'string'
        }
      ],
      payable: false,
      stateMutability: 'view',
      type: 'function'
    },
    {
      constant: false,
      inputs: [
        {
          internalType: 'uint8',
          name: 'prop',
          type: 'uint8'
        },
        {
          internalType: 'bool',
          name: 'ans',
          type: 'bool'
        }
      ],
      name: 'vote',
      outputs: [],
      payable: false,
      stateMutability: 'nonpayable',
      type: 'function'
    }
  ];