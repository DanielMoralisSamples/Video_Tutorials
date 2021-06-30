const response = await fetch('YOURLINK', {
    method: 'GET',
    headers: new Headers({
        'accept':'*/*',
        'Authorization': 'YOUR AUTHORIZATION JWT'
    })
})
console.log(await response.json())