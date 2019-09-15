const router = require("express").Router();
const admin = require("firebase-admin");
const accountSid = 'AC192a9e000b0e626cbf34faeaa5a52534';
const authToken = '7393916dea8ba6c85aa564545c694e85';
const client = require('twilio')(accountSid, authToken);
const db = admin.firestore();

module.exports = router.post("/analytics",(req,res)=>{
    let body = req.body;
    if(body){
        let count = Math.floor((Math.random() * 10) + 1);
        body['timesLoggedIn'] = count
        if(!req.body['success']) {
            sendText()
            return res.status(200).send({
                status:"Unknown - Authorities Notified - Successfully Saved Entry",
                saved:body
            });
        }
        db.collection('userInfo').doc().set(body);

        return res.status(200).send({
            status:"Authenticated - Successfully saved entry",
            saved:body
        });
    }
    else{
        res.status(400).send({
            status:"Invalid request",
            saved:undefined
        })
    }
});

const sendText=()=>{
  client.messages
  .create({
     body: 'Someone is trying to open your locked door',
     from: '+16476961841',
     to: '+16474052255'
   })
  .then(message => console.log(message.sid))
  .catch((err)=>console.log(err))
}

