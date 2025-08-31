import { Badge } from 'flowbite-react';
import { TbChefHat as ChefHat } from 'react-icons/tb';

function ViewRecipe({ difficulty }: { difficulty: string }) {
  const difficultyColors = {
    easy: "bg-green-100 text-green-800",
    medium: "bg-yellow-100 text-yellow-800",
    hard: "bg-red-100 text-red-800"
  };

  const defaultColors = 'bg-gray-100 text-gray-800';

  return (
    <Badge icon={ChefHat} className={`${difficultyColors[difficulty] || defaultColors} pointer-events-none`}>
      {difficulty || "Unknown"}
    </Badge>
  );
}

export default ViewRecipe;
