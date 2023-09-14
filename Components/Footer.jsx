import {Fot1,Fot2} from "../Components/index";
export default()=>{
    const footerNavs=[
        {
            href:"javascript:void()",
            name:"Terms",
        },
        {
            href:"javascript:void()",
            name:"License",
        },
        {
            href:"javascript:void()",
            name:"Primary",
        },
        {
            href:"javascript:void()",
            name:"About us",
        },
    ];
    return (
        <footer className="pt-10">
            <div className="max-w-scrren-xl mx-auto px-4 text-gray-600 md:px-8">
                <div className="space-y-6">
                    <img src="https://www.floatui.com/logo.svg" className="w-32 " />
                    <p className="max-w-mid">
                        Nulla auctor metus vitar lectus iaculis, vel quismod massa efficitur.
                    </p>
                    <ul className="flex flex-wrap items-center gap-4 text-sm sm:text-base">
                        {footerNavs.map((item,idx)=>(
             <li className="text-gray-800 hover:text-gray-500 duration-150">
                <a key={idx} href={item.href}>
                    {item.name}
                </a>
             </li>               
                        ))}
                    </ul>
                </div>
                <div className="mt-6">
                <p className="text-gray-700 font-semibold">Get the app</p>
                <div className="flex items-center gap-3 mt-3 sm:block">
                    <a href="javascript:void()">
                        <Fot1 />
                    </a>
                    <a href="javascript:void()"className="mt-0 block sm:mt-3">
                        <Fot2/>
                    </a>
                    </div>
                    </div>
                </div>
            <div className="mt-10 py-10 border-t md:text-center">
                <p> © 2023 ByteCraft. All rights reserved. </p>
            </div>
        </footer>
    );

};
