
console.log 'starting...'

hello = require ('./hello')
console.log hello.echo('is anyone there?')

t = new hello.testClass()
console.log t.sayHello('Bob')

console.log '... and done'
