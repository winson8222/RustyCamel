(* Simple literal example *)
let _sample_literal = "{\"tag\": \"blk\", \"body\": {\"tag\": \"lit\", \"val\": 1}}"

(* Example with const and name reference *)
let _sample_const_and_nam = "{\"tag\": \"blk\", \"body\": {\"tag\": \"seq\", \"stmts\": [{\"tag\": \"const\", \"sym\": \"y\", \"expr\": {\"tag\": \"lit\", \"val\": 4}}, {\"tag\": \"binop\", \"sym\": \"*\", \"frst\": {\"tag\": \"nam\", \"sym\": \"y\"}, \"scnd\": {\"tag\": \"lit\", \"val\": 2}}]}}"

(* Example with let and name reference *)
let _sample_let_and_nam = "{\"tag\": \"blk\", \"body\": {\"tag\": \"seq\", \"stmts\": [{\"tag\": \"let\", \"sym\": \"y\", \"expr\": {\"tag\": \"lit\", \"val\": 4}}, {\"tag\": \"binop\", \"sym\": \"*\", \"frst\": {\"tag\": \"nam\", \"sym\": \"y\"}, \"scnd\": {\"tag\": \"lit\", \"val\": 2}}]}}"