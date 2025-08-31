import { create } from 'zustand';
import { combine } from 'zustand/middleware';

import type { Artifact } from 'types/messages';

type ArtifactsStoreState = {
  artifacts: Artifact[];
};

type ArtifactsStoreActions = {
  setArtifacts: (artifacts: Artifact[]) => void;
  addArtifact: (artifact: Artifact) => void;
  clearArtifacts: () => void;
};

type ArtifactsStore = ArtifactsStoreState & ArtifactsStoreActions;

export const useArtifactsStore = create<ArtifactsStore>(
  combine({ artifacts: [] }, (set) => {
    return {
      setArtifacts: (artifacts: Artifact[]) => {
        set(() => ({
          artifacts,
        }))
      },
      addArtifact: (artifact: Artifact) => {
        set((state) => ({
          artifacts: [...state.artifacts, artifact],
        }))
      },
      clearArtifacts: () => {
        set(() => ({
          artifacts: [],
        }))
      }
    }
  }),
);

export const setArtifacts = (artifacts: Artifact[]) => useArtifactsStore.getState().setArtifacts(artifacts);
export const addArtifact = (artifact: Artifact) => useArtifactsStore.getState().addArtifact(artifact);
export const clearArtifacts = () => useArtifactsStore.getState().clearArtifacts();
