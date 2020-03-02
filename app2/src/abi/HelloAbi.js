export const HelloAbi = [
    {
      constant: false,
      inputs: [
        {
          internalType: 'string',
          name: 'prop1',
          type: 'string'
        },
        {
          internalType: 'string',
          name: 'prop2',
          type: 'string'
        }
      ],
      name: 'createSubmission',
      outputs: [],
      payable: false,
      stateMutability: 'nonpayable',
      type: 'function'
    },
    {
      constant: true,
      inputs: [],
      name: 'getPropNum',
      outputs: [
        {
          internalType: 'contract Submission',
          name: '',
          type: 'address'
        },
        {
          internalType: 'uint8',
          name: '',
          type: 'uint8'
        }
      ],
      payable: false,
      stateMutability: 'view',
      type: 'function'
    }
  ];