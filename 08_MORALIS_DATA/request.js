const response = await fetch('https://to6yj724p7wc.moralis.io:2053/api/account/erc20/balances?chain=bsc&chain_name=testnet&address=0xbA6AADA3F43521296f92cdD6730108E13b927c1c', {
    method: 'GET',
    headers: new Headers({
        'accept':'*/*',
        'Authorization':'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJoaXN0b3JpY0FwaSI6dHJ1ZSwiYWNjb3VudEFwaSI6dHJ1ZSwidG9rZW5BcGkiOnRydWUsImlhdCI6MTYyNTAzNTA0MCwiZXhwIjoxNjI1MDM4NjQwfQ.nRPGLWr4SB-V1IfENqoAW91Aeo7wZaWYTc5N3PXAYD8'
    })
})
console.log(await response.json())