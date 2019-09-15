const router = require("express").Router();
const admin = require("firebase-admin");
const db = admin.firestore();

module.exports = router.post("/analytics",(req,res)=>{
    let body = req.body;
    if(body){
        console.log("SUcess")
        db.collection('userInfo').doc().set(body);
        res.status(200).send({
            status:"Succesful",
            saved:body
        })
    }
    else{
        res.status(400).send({
            status:"Invalid request",
            saved:undefined
        })
    }
});