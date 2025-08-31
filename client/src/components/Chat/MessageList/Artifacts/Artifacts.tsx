import ViewRecipe from 'components/Chat/MessageList/Artifacts/ViewRecipe/ViewRecipe';
import { useArtifactsStore } from 'stores/artifactsStore';
import { Artifact } from 'types/messages';
import { RecipeCard } from 'types/recipes';

function Artifacts() {
  const { artifacts } = useArtifactsStore();

  const renderArtifact = (artifact: Artifact) => {
    switch (artifact.kind) {
      case 'recipe_created':
      case 'recipe_updated':
        return <ViewRecipe recipe={artifact.data as RecipeCard} />;
      default:
        return null;
    }
  };

  return (
    <div className="flex flex-col gap-4">
      {artifacts.map((artifact, index) => (
        <div key={index}>
          {renderArtifact(artifact)}
        </div>
      ))}
    </div>
  );
}

export default Artifacts;
