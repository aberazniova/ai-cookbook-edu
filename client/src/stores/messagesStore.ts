import { create } from 'zustand';
import { combine } from 'zustand/middleware';

import type { Message } from 'types/messages';

type MessagesStoreState = {
  messages: Message[];
  responseLoading: boolean;
};

type MessagesStoreActions = {
  addMessage: (message: Message) => void;
  setMessages: (messages: Message[]) => void;
  setResponseLoading: (loading: boolean) => void;
};

type MessagesStore = MessagesStoreState & MessagesStoreActions;

export const useMessagesStore = create<MessagesStore>(
  combine({ messages: [], responseLoading: false }, (set) => {
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
      setResponseLoading: (loading: boolean) => {
        set(() => ({
          responseLoading: loading,
        }))
      },
    }
  }),
);
