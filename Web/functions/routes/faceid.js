const router = require("express").Router();
var admin = require("firebase-admin");

let db = admin.firestore();

module.exports = router.get("/faceid",(req,res)=>{
    let users = []
    db.collection("faceId").get().then((data)=>{
        data.forEach(data=>{
            users.push(data.data())
        });
        
        res.status(200).send(JSON.stringify(users));
    }).catch(()=>{
        res.status(500).send({
            status:"Failed"
        });
    });
});
