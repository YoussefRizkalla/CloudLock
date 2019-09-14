const router = require("express").Router();
var admin = require("firebase-admin");

let db = admin.firestore();

router.post("/putToFirebase",(req,res)=>{
    let body = req.body;
    if(body) {
        db.collection("faceId").doc().set(body);
        return res.status(200).send({
            status:"OK"
        })
    }
    else{
        return res.status(400).send({
            status:"Failed"
        });
    }
});

module.exports = router;