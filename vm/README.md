
## Sample JSON
### Literal
`{"tag": "blk", "body": {"tag": "lit", "val": 1}}`

### Function
`{"tag":"blk","body":{"tag":"seq","stmts":[{"tag":"fun","sym":"factorial","prms":[{"type":"Param","name":"n","paramType":{"type":"BasicType","name":"i32"}}],"body":{"tag":"blk","body":{"tag":"lit"}}},{"tag":"app","fun":{"tag":"nam","sym":"factorial"},"args":[{"tag":"lit","val":5}]}]}}`
