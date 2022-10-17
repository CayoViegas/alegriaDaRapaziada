const fetch = require("node-fetch");
const { resolve } = require("path");

let highelo = [];

var myInit = {
  method: "GET",
  headers: {
    "X-Riot-Token": "RGAPI-ca1a0bbd-99e4-400c-ade2-493691245d7f",
  },
  mode: "cors",
  cache: "default",
};

function url(elo) {
  return `https://br1.api.riotgames.com/lol/league/v4/${elo}/by-queue/RANKED_SOLO_5x5`;
}

function teste() {
  return fetch(url(ranks[0]), myInit)
    .then(function (response) {
      return response.json();
    })
    .then(function (data) {
      let promises = data.entries.map((element) => {
        return element.summonerName;
      });

      return Promise.all(promises);
    });
}

teste().then((galera) => {
  console.log(galera);
});

function teste(arrayqlqr) {
  let promisesasd = [];

  for (let index = 0; index < arrayqlqr.length; index++) {
    fetch(url(ranks[index]), myInit)
      .then(function (response) {
        return response.json();
      })
      .then(function (data) {
        let promises = data.entries.map((element) => {
          return element.summonerName;
        });

        promisesasd.push[promises];
      });
  }

  return Promise.all(promisesasd);
}

async function getLista(liga) {
  return await fetch(url(liga), myInit)
    .then((data) => {
      return data.json();
    })
    .then((data) => {
      return data.entries;
    });
}

async function getCu() {
  const ranks = ["challengerleagues", "grandmasterleagues", "masterleagues"];
  let players = [];
  for (let i = 0; i < ranks.length; i++) {
    let meucu = await getLista(ranks[i]);

    for (let y = 0; y < meucu.length; y++) {
      players.push(meucu[y].summonerName);
    }
  }

  console.log(players);
}

getCu();
