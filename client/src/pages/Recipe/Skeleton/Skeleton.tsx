function Skeleton() {
  return (
    <div className="min-h-screen p-6 md:p-8 bg-cream">
      <div className="max-w-4xl mx-auto">
        <div className="animate-pulse space-y-6">
          <div className="h-8 bg-gray-200 rounded w-1/3"></div>
          <div className="h-64 bg-gray-200 rounded-2xl"></div>
          <div className="h-6 bg-gray-200 rounded w-2/3"></div>
          <div className="space-y-3">
            {Array(5).fill(0).map((_, i) => (
              <div key={i} className="h-4 bg-gray-200 rounded"></div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}

export default Skeleton;
