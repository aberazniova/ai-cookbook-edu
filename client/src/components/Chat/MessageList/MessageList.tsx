import Message from 'components/Chat/MessageList/Message/Message';
import { type Message as MessageType } from 'types/messages';

function MessageList() {
  const messages: MessageType[] = [
    {
      text: "Hi there! How can I help you with recipes today?",
      isUserMessage: false
    },
    {
      text: "I'm looking for a vegetarian dinner recipe.",
      isUserMessage: true
    },
    {
      text: "Certainly, there's a great recipe for pumpkin cream soup with ginger and coconut milk! It's very warming on cold days. Would you like the details?",
      isUserMessage: false
    },
    {
      text: "Sounds delicious! How about something like fast food, but vegetarian?",
      isUserMessage: true
    },
    {
      text: "You could try vegetarian black bean burgers or vegetable fajitas with spicy sauce! Both options are quick to prepare and very tasty.",
      isUserMessage: false
    },
    {
      text: "Great! Fajitas, please.",
      isUserMessage: true
    },
    {
      text: "Excellent choice! For fajitas, you'll need bell peppers, onions, mushrooms, tortillas, and of course, spices: cumin, paprika, chili. Sauté the vegetables, wrap them in tortillas, and add your favorite sauce! Enjoy your meal!",
      isUserMessage: false
    },
    {
      text: "Thanks! You've been very helpful.",
      isUserMessage: true
    },
    {
      text: "Always happy to help! Feel free to ask if you need more recipes or tips.",
      isUserMessage: false
    }
  ];

  return (
    <div className="flex-1 p-5 lg:p-6 overflow-y-auto custom-scrollbar">
      {messages.map((message, index) => (
        <Message key={index} message={message} />
      ))}
    </div>
  );
}

export default MessageList;
