module.exports = (label) => {
  return {
    type: 'item',
    labels: {
      en: label,
    },
    descriptions: {
      en: 'politician in Zambia',
    },
    claims: {
      P31: { value: 'Q5' }, // human
      P106: { value: 'Q82955' }, // politician
      P39: {
        value: 'Q18607856',
        qualifiers: {
          P2937: 'Q45380990'
        },
        references: {
          P854: 'https://www.parliament.gov.zm/members/12-assembly'
        },
      }
    }
  }
}
