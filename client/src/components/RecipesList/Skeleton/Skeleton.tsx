function Skeleton() {
  return (
    <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
      {Array(4).fill(0).map((_, i) => (
        <div key={i} className="bg-white rounded-2xl shadow-md animate-pulse">
          <div className="h-48 bg-gray-200 rounded-t-2xl"></div>
          <div className="p-5 space-y-3">
            <div className="h-4 bg-gray-200 rounded w-3/4"></div>
            <div className="h-3 bg-gray-200 rounded w-1/2"></div>
          </div>
        </div>
      ))}
    </div>
  );
}

export default Skeleton;
