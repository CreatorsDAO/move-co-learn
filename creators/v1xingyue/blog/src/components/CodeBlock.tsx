
export function CodeBlock({
  code
}: {
  code: any;
}) {
  return (
    <div className="mt-4">
      <pre className="p-4 bg-gray-100"><code>{JSON.stringify(code, undefined, 2)}</code></pre>
    </div>
  );
}
