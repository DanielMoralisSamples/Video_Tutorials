const response = await fetch('YOURQUERY LINK', {
    method: 'GET',
    headers: new Headers({
        'accept':'*/*',
        'Authorization':'YOUR AUTHORIZATION ID'
    })
})
console.log(await response.json())