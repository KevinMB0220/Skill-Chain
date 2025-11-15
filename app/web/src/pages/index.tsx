import Head from 'next/head';

export default function Home() {
  return (
    <>
      <Head>
        <title>SkillChain - On-Chain Professional Reputation</title>
        <meta
          name="description"
          content="Decentralized professional reputation protocol built on Polkadot"
        />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <link rel="icon" href="/favicon.ico" />
      </Head>
      <main className="min-h-screen bg-gradient-to-b from-gray-50 to-gray-100">
        <div className="container mx-auto px-4 py-16">
          <div className="text-center">
            <h1 className="text-6xl font-bold text-gray-900 mb-4">
              Skill<span className="text-primary-600">Chain</span>
            </h1>
            <p className="text-xl text-gray-600 mb-8">
              On-Chain Professional Reputation Protocol
            </p>
            <p className="text-gray-500 max-w-2xl mx-auto">
              Build your verifiable professional reputation on Polkadot.
              Register achievements, receive endorsements, and showcase your
              validated skills to the world.
            </p>
          </div>

          <div className="mt-16 grid grid-cols-1 md:grid-cols-3 gap-8 max-w-5xl mx-auto">
            <div className="bg-white rounded-lg shadow-md p-6">
              <h3 className="text-xl font-semibold mb-3">Decentralized</h3>
              <p className="text-gray-600">
                Your reputation lives on-chain, owned by you, verified by the
                network.
              </p>
            </div>
            <div className="bg-white rounded-lg shadow-md p-6">
              <h3 className="text-xl font-semibold mb-3">Verifiable</h3>
              <p className="text-gray-600">
                All claims are cryptographically signed and publicly auditable.
              </p>
            </div>
            <div className="bg-white rounded-lg shadow-md p-6">
              <h3 className="text-xl font-semibold mb-3">Portable</h3>
              <p className="text-gray-600">
                Take your reputation anywhere in the Web3 ecosystem.
              </p>
            </div>
          </div>

          <div className="mt-12 text-center">
            <button
              className="bg-primary-600 text-white px-8 py-3 rounded-lg font-semibold hover:bg-primary-700 transition-colors"
              disabled
            >
              Connect Wallet (Coming Soon)
            </button>
          </div>
        </div>
      </main>
    </>
  );
}

