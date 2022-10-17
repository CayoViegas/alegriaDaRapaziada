const TwitterPackage = require("twitter");

const secret = require("./config");

const elogios = require('./elogios.json'); 

const Tweets = require('./tweets.json').tweets;

const Twitter = new TwitterPackage(secret);


function classificaString(tweet){ 

    let retorno = "";
    let substrings = ["feia", "feio", "burra", "burro", "insuficiente"]
    tweet.toLowerCase().split(' ').forEach(element => {
        substrings.forEach(substring => {
            if(substring == element) {
                retorno = element;
            }
        });
    });

    return retorno;
}

function getRandomElogio(elogios) {
    return elogios[Math.floor(Math.random() * elogios.length)];
}


function getElogio(elogios, classificacao) {

    let retorno = "";

    switch (classificacao) {
        case "feio":
            retorno = getRandomElogio(elogios.masculino_aparencia);
            break;
    
        case "burro":
            retorno = getRandomElogio(elogios.masculino_inteligencia); 
            break;
   
        case "feia":
            retorno = getRandomElogio(elogios.feminino_aparencia); 
            break;
            
        case "burra":
            retorno = getRandomElogio(elogios.feminino_inteligencia); 
            break;
            
        case "insuficiente":
            retorno = getRandomElogio(elogios.suficiencia); 
            break;
        }
    
    return retorno;

}

function filtraTweet(tweet) {
    let tweets = Tweets.split(',');
    if (new RegExp(tweets.join("|")).test(tweet)) return true;
    else return false;
}

function removeEmojis (string) {
    var regex = /(?:[\u2700-\u27bf]|(?:\ud83c[\udde6-\uddff]){2}|[\ud800-\udbff][\udc00-\udfff]|[\u0023-\u0039]\ufe0f?\u20e3|\u3299|\u3297|\u303d|\u3030|\u24c2|\ud83c[\udd70-\udd71]|\ud83c[\udd7e-\udd7f]|\ud83c\udd8e|\ud83c[\udd91-\udd9a]|\ud83c[\udde6-\uddff]|\ud83c[\ude01-\ude02]|\ud83c\ude1a|\ud83c\ude2f|\ud83c[\ude32-\ude3a]|\ud83c[\ude50-\ude51]|\u203c|\u2049|[\u25aa-\u25ab]|\u25b6|\u25c0|[\u25fb-\u25fe]|\u00a9|\u00ae|\u2122|\u2139|\ud83c\udc04|[\u2600-\u26FF]|\u2b05|\u2b06|\u2b07|\u2b1b|\u2b1c|\u2b50|\u2b55|\u231a|\u231b|\u2328|\u23cf|[\u23e9-\u23f3]|[\u23f8-\u23fa]|\ud83c\udccf|\u2934|\u2935|[\u2190-\u21ff])/g;
  
    return string.replace(regex, '');
}

Twitter.stream('statuses/filter', { track: Tweets}, function (stream) {
    stream.on('data', function (tweet) {

        let tweetClean = removeEmojis(tweet.text);

        if(tweet.retweeted_status == undefined && !tweet.is_quote_status && tweet.in_reply_to_status_id == null && filtraTweet(tweetClean)) {
            console.log(tweet.text);

            let elogio = getElogio(elogios, classificaString(tweetClean));
            console.log(elogio);
            Twitter.post('statuses/update', { status: elogio, in_reply_to_status_id: tweet.id_str, auto_populate_reply_metadata: true }, function (error, tweet, response) {
                if (error) console.log(error);
            });
        }

    });

    stream.on('error', function (error) {
        console.log(error);
    });
});
