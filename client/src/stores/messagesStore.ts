import { create } from 'zustand';
import { combine } from 'zustand/middleware';

import type { Message } from 'types/messages';

type MessagesStoreState = { messages: Message[] };

type MessagesStoreActions = {
  addMessage: (message: Message) => void;
  setMessages: (messages: Message[]) => void;
};

type MessagesStore = MessagesStoreState & MessagesStoreActions;

export const useMessagesStore = create<MessagesStore>(
  combine({ messages: [] }, (set) => {
    return {
      addMessage: (message: Message) => {
        set((state) => ({
          messages: [...state.messages, message],
        }))
      },
      setMessages: (messages: Message[]) => {
        set(() => ({
          messages,
        }))
      },
    }
  }),
);
