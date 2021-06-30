const response = await fetch('https://to6yj724p7wc.moralis.io:2053/api/account/erc20/balances?chain=bsc&chain_name=testnet&address=0xbA6AADA3F43521296f92cdD6730108E13b927c1c', {
    method: 'GET',
    headers: new Headers({
        'accept':'*/*',
        'Authorization': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJoaXN0b3JpY0FwaSI6dHJ1ZSwiYWNjb3VudEFwaSI6dHJ1ZSwidG9rZW5BcGkiOnRydWUsImlhdCI6MTYyNDk2MjE3MywiZXhwIjoxNjI0OTY1NzczfQ.rLQsMBPCVyelgImnPr8O4htfc2Gg-tdcoSHgC1L_FhY'
    })
})
console.log(await response.json())