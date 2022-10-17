import { React, useState } from 'react'
import reactLogo from './assets/react.svg'
import './App.css'

function App() {
  const [count, setCount] = useState(0)
  const [showimage, setShowimage] = useState(false)

  return (
    <div className="App">
    
      <h1>Vite + React</h1>
      <div className="card">
        <button onClick={() => setCount(count + 1)}>
          count is {count}
        </button>
        <button onClick={()=> setShowimage(!showimage)}>
          {showimage ?  'Esconder' : 'Mostrar'}
        </button>
        
        {showimage && (
            <div>
            <a href="https://vitejs.dev" target="_blank">
              <img src="/vite.svg" className="logo" alt="Vite logo" />
            </a>
            <a href="https://reactjs.org" target="_blank">
              <img src={reactLogo} className="logo react" alt="React logo" />
            </a>
            <p className="read-the-docs">
             Click on the Vite and React logos to learn more
            </p>
          </div>
        )}
      </div>    
    </div>
  )
}

export default App
