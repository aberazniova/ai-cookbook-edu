import {
  FiClock as Clock,
  FiUsers as Users,
  FiPlus as Plus,
  FiMinus as Minus
} from 'react-icons/fi';
import { TbChefHat as ChefHat } from 'react-icons/tb';

type Props = {
  cookingTime: number,
  servings: number,
  difficulty: string,
  onServingsChanged: (servings: number) => void,
};

function RecipeStats({ cookingTime, servings, difficulty, onServingsChanged }: Props) {
  const decrementServingsDisabled = servings <= 1;
  const incrementServingsDisabled = servings >= 99;

  const incrementServings = () => {
    if (incrementServingsDisabled) return;

    onServingsChanged(servings + 1);
  };

  const decrementServings = () => {
    if (decrementServingsDisabled) return;

    onServingsChanged(servings - 1);
  };

  return (
    <div className="grid grid-cols-2 md:grid-cols-3 gap-6 mb-8">
      <div className="text-center">
        <div className="w-12 h-12 mx-auto mb-2 rounded-full flex items-center justify-center bg-sage-green-200">
          <Clock className="w-6 h-6 text-sage-green" />
        </div>
        <p className="text-sm text-gray-500">Cooking Time</p>
        <p className="font-semibold">{cookingTime || 0} min</p>
      </div>
      <div className="text-center">
        <div className="w-12 h-12 mx-auto mb-2 bg-purple-100 rounded-full flex items-center justify-center">
          <Users className="w-6 h-6 text-purple-600" />
        </div>
        <p className="text-sm text-gray-500">Servings</p>
        <div className="flex items-center justify-center gap-2">
          <button
            type="button"
            className="w-6 h-6 flex items-center justify-center disabled:opacity-50"
            onClick={decrementServings}
            disabled={decrementServingsDisabled}
            data-testid="recipe-stats-decrement-button"
          >
            <Minus className="w-3 h-3" />
          </button>
          <p className="font-semibold">{servings}</p>
          <button
            type="button"
            className="w-6 h-6 flex items-center justify-center"
            onClick={incrementServings}
            disabled={incrementServingsDisabled}
            data-testid="recipe-stats-increment-button"
          >
            <Plus className="w-3 h-3" />
          </button>
        </div>
      </div>
      <div className="text-center">
        <div className="w-12 h-12 mx-auto mb-2 bg-yellow-100 rounded-full flex items-center justify-center">
          <ChefHat className="w-6 h-6 text-yellow-600" />
        </div>
        <p className="text-sm text-gray-500">Difficulty</p>
        <p className="font-semibold capitalize">{difficulty}</p>
      </div>
    </div >
  );
}

export default RecipeStats;
