import { motion } from "framer-motion";

export default function CommunityRecipesPage() {
  return (
    <div className="min-h-full p-6 md:p-8 bg-cream">
      <div className="max-w-7xl mx-auto">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          className="text-center py-32"
        >
          <div className="text-8xl mb-6">🍳</div>
          <h1 className="text-4xl font-bold text-gray-900 mb-4">
            Community Recipes
          </h1>
          <p className="text-xl text-gray-600">
            Coming soon...
          </p>
        </motion.div>
      </div>
    </div>
  );
}
