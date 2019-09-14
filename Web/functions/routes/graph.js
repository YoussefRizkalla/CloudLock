const router = require("express").Router();
var admin = require("firebase-admin");
let db = admin.firestore();

module.exports = router.get("/graphs",(req,res)=>{
    let users = []
    db.collection("faceId").get().then((data)=>{
        data.forEach(data=>users.push(data.data()));
        res.render("graph",{users:users});
    }).catch(()=>{
        res.render("graph",{users:[]})
    })
})