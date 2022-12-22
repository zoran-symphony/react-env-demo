import logo from "./logo.svg";
import "./App.css";
import { getEnvs } from "./env";

function App() {
  return (
    <div className="App">
      <header className="App-header">
        <img src={logo} className="App-logo" alt="logo" />

        <ul>
          {Object.entries(getEnvs()).map(([key, val]) => (
            <li>
              {key}: {val}
            </li>
          ))}
        </ul>
      </header>
    </div>
  );
}

export default App;
