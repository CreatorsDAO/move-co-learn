

type SwordListPros = { swords: Array<{ id: string, magic: number, strength: number }>, transfer: Function };
export function SwordList({ swords, transfer }: SwordListPros) {
    return swords && (
        <div className="card lg:card-side bg-base-100 shadow-xl mt-5">
            <div className="card-body">
                <h2 className="card-title">swords list:</h2>

                <div className="overflow-x-auto">
                    <table className="table w-full">
                        <thead>
                            <tr>
                                <th>Id</th>
                                <th>Magic</th>
                                <th>Strength</th>
                                <th>Operate</th>
                            </tr>
                        </thead>
                        <tbody>

                            {
                                swords.map((item, i) =>
                                    <tr key={item.id}>
                                        <th>{item.id}</th>
                                        <td>{item.magic}</td>
                                        <td>{item.strength} </td>
                                        <td>
                                            <a className="link link-hover link-primary" onClick={() => { transfer(item.id) }}>Transfer</a>
                                        </td>
                                    </tr>
                                )
                            }
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    )
}