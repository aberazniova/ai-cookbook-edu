
import { useState, useRef } from 'react';
import { Card } from 'flowbite-react';
import ReactMarkdown from 'react-markdown';
import {
  FiUpload as Upload,
} from 'react-icons/fi';
import { FaSpinner as Loader2 } from 'react-icons/fa';

import { type Recipe } from 'types/recipes';
import { useAlertStore } from 'stores/alertStore';
import { defaultRecipeImageBanner } from 'utils/defaultRecipeImages';
import RecipeStats from './RecipeStats/RecipeStats';
import Ingredients from './Ingredients/Ingredients';

type Props = {
  recipe: Recipe,
  loading: boolean,
};

function RecipeDetails({ recipe }: Props) {
  const [isUploading, setIsUploading] = useState(false);
  const [displayedServings, setDisplayedServings] = useState(recipe.servings);
  const fileInputRef = useRef<HTMLInputElement | null>(null);

  const addAlert = useAlertStore((state) => state.addAlert);

  const handleImageUpload = async (event: React.ChangeEvent<HTMLInputElement>) => {
    const file = event?.target?.files?.[0];
    if (!file) return;

    setIsUploading(true);
    try {
      // TODO: implement real upload
      await new Promise((res) => setTimeout(res, 1000));
      addAlert({ type: 'success', message: 'Image uploaded (simulated).' });
    } catch (error) {
      addAlert({ type: 'failure', message: error.message || 'Image upload failed.' });
    } finally {
      setIsUploading(false);
    }
  };

  return (
    <Card className="bg-white shadow-xl border-0 rounded-3xl overflow-hidden text-left">
      <div className="relative h-80 overflow-hidden">
        <img
          src={recipe.imageUrl || defaultRecipeImageBanner}
          alt={recipe.title}
          className="w-full h-full object-cover"
        />
        <div className="absolute inset-0 bg-gradient-to-t from-black/50 to-transparent"></div>
        <div className="absolute bottom-6 left-6 right-6 text-white">
          <h1 className="text-3xl md:text-4xl font-bold mb-2">{recipe.title}</h1>
        </div>

        <button
          type="button"
          className={`
            absolute top-6 right-6 bg-white/20 backdrop-blur-sm hover:bg-white/30 text-white rounded-md
            p-2 w-10 h-10 flex items-center justify-center hidden
          `}
          onClick={() => fileInputRef.current?.click()}
          disabled={isUploading}
          data-testid="recipe-details-upload-button"
        >
          {isUploading ? <Loader2 className="w-5 h-5 animate-spin" /> : <Upload className="w-5 h-5" />}
        </button>
        <input
          type="file"
          data-testid="recipe-details-upload-input"
          ref={fileInputRef}
          onChange={handleImageUpload}
          className="hidden"
          accept="image/*"
        />
      </div>

      <div className="p-8">
        <RecipeStats
          cookingTime={recipe.cookingTime}
          servings={displayedServings}
          difficulty={recipe.difficulty}
          onServingsChanged={setDisplayedServings}
        />

        <div className="mb-8">
          <h2 className="text-xl font-bold text-gray-900 mb-3">Summary</h2>
          <p className="text-gray-700 leading-relaxed">
            {recipe.summary || "No summary available."}
          </p>
        </div>

        <Ingredients ingredients={recipe.ingredients} originalServings={recipe.servings} displayedServings={displayedServings} />

        <div className="mb-8">
          <h2 className="text-xl font-bold text-gray-900 mb-4">Instructions</h2>
          <div
            className={`
              space-y-4 prose prose-gray dark:prose-invert prose-p:text-gray-700 dark:prose-p:text-gray-200
              prose-strong:text-gray-900 dark:prose-strong:text-gray-100 text-base
              lg:text-lg prose-p:mb-3 prose-p:mt-0 leading-relaxed prose-ul:pl-4
            `}
          >
            <ReactMarkdown>
              {recipe.instructions}
            </ReactMarkdown>
          </div>
        </div>
      </div>
    </Card>
  );
}

export default RecipeDetails;
