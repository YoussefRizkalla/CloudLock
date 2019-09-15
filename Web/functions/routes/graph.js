const router = require("express").Router();
var admin = require("firebase-admin");
let db = admin.firestore();

module.exports = router.get("/graphs",(req,res)=>{
    let users = []
    db.collection("faceId").get().then((data)=>{
        users.push([])
        data.forEach(data=>users[0].push(data.data()));

        users.push([])
        db.collection("userInfo").get().then(data=>{
            data.forEach(data => users[1].push(data.data()));
            console.log({users:users});
            res.render("graph",{userData:users})
        })
    }).catch(()=>{
        res.render("graph",{users:[]})
    })
})