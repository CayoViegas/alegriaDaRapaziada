greetPlayer();

var cardsTurned;
var numRounds;
var clk;
var clkInterval;
function greetPlayer(){
    let isNumValid = false;
    let numCards;
    cardsTurned = 0;
    numRounds = 0;
    clk = -1;

    clkInterval = setInterval(updateClock,1000);

    do{
        numCards = Number(prompt("Bem vindo! Qual será o número de cartas? (4-14)"));
        console.log(numCards);

        if(numCards < 4 || numCards > 14 || numCards % 2 !== 0 || !numCards){
            alert("Número de Cartas Inválido!");
        } 
        else{
            isNumValid = true;
        }

    } while(!isNumValid);

    generateCards(numCards);
}

function generateCards(numCards){
    const cardsContainer = document.querySelector(".cards-container");
    let gameDeck = buildGameDeck(numCards);

    cardsContainer.innerHTML = "";
    for(let i= 0 ; i < numCards; i++){
        cardsContainer.innerHTML += `
            <div class="card unmatched" onclick="turnCard(this)">
                <div class="back-face">
                    <img src=${gameDeck[i]} >
                </div>
            <div>
            `;
    }
}

function buildGameDeck(numCards){
    const deck = getFullDeck().slice(0,(numCards));
    deck.sort(sorter);
    return deck;
}

function getFullDeck(){
    const bob = "../media/bobrossparrot.gif";
    const explody = "../media/explodyparrot.gif";
    const fiesta = "../media/fiestaparrot.gif";
    const metal = "../media/metalparrot.gif";
    const revert = "../media/revertitparrot.gif";
    const triplet = "../media/tripletsparrot.gif";
    const unicorn = "../media/unicornparrot.gif";
    
    let facesArray = [bob,bob,explody,explody,fiesta,fiesta,metal,metal,revert,revert,triplet,triplet,unicorn,unicorn];

    return facesArray;
}

function sorter(){
    return Math.random() - 0.5;
}

function turnCard(card){
    let backImage = card.querySelector(".back-face img");

    card.classList.add("turned");
    backImage.style.opacity = 1;
    cardsTurned++;

    if(cardsTurned == 2){
        setTimeout(checkCards,1000);
        cardsTurned = 0;
    }
}

function checkCards(){
    let turnedCards = document.querySelectorAll(".turned.unmatched");
    let cardImgs = [];

    for(card of turnedCards){
        cardImgs.push(card.querySelector(".back-face img"));
    }
    
    if(cardImgs[0].src === cardImgs[1].src){
        for(card of turnedCards){
            card.classList.remove("unmatched");
        }
    } 

    else{
        for(let i=0; i< turnedCards.length; i++){
            turnedCards[i].classList.remove("turned");
            cardImgs[i].style.opacity = 0;
        }
    }

    numRounds++;
    checkFinished();
}

function checkFinished(){
    let unmatchedCards = document.querySelector(".unmatched");
    if(!unmatchedCards){
        clearInterval(clkInterval);
        alert("Você ganhou em " + numRounds + " jogadas! (" + clk + " seg)");
        let playerOpt = prompt("Você gostaria de jogar outra partida? (s/n)");

        if(playerOpt==='s'){
            greetPlayer();
        } else {
            alert("Obrigado por jogar!");
        }
       
    }
}

function updateClock(){
    let clock = document.querySelector(".clock-time");
    clk++;
    clock.innerHTML = clk;
}