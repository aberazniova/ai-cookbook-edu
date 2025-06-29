import './Chat.css';
import { ToggleSwitch } from "flowbite-react";
import { useState } from "react";

function Chat() {
  const [switch1, setSwitch1] = useState(false);

  return (
    <header className="chat">
      <p>
        Hello, how can I assist you today?
      </p>
      <ToggleSwitch checked={switch1} label="Toggle me" onChange={setSwitch1} />
    </header>
  );
}

export default Chat;
