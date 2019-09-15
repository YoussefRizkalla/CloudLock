const router = require("express").Router();
var admin = require("firebase-admin");
let db = admin.firestore();

module.exports = router.get("/graphs",(req,res)=>{
    let users = [];
    db.collection("userInfo").get().then(data=>{
        data.forEach(data => users.push(data.data()));
        res.render("graph",{userData:users})
    })
    .catch(()=>{
        res.render("graph",{userData:users})
    });
});