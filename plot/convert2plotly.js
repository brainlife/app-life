const fs = require('fs');

const hcp3t = require('./HCP3T90.json');
const hcp7t = require('./HCP7T60.json');
const stn96 = require('./STN96.json');

var data = [];

//add references
function add(input, dsname) {
        for(let s = 0;s < input.subject_set.length;s++) {
                var nnz_means = input.nnz_mean[s];
                var nnz_std = input.nnz_std[s];
                var rmse_means = input.rmse_mean[s];
                var rmse_std = input.rmse_std[s];
                var c = input.c[s];

                //for(let a = 0;a < input.alg_names.length;a++) {
                //console.log(input.subject_set[s]+" "+input.alg_names[a]);
                        data.push({
                                mode: 'markers',
                                //name: input.subject_set[s]+" "+input.alg_names[a],
                                name: dsname+ " " +input.subject_set[s],
                                //x: [ rmse_means[a] ] ,
                                //y: [ nnz_means[a] ],
                                x: rmse_means,
                                y: nnz_means,
                                error_x: {
                                    type: 'data',
                                    //array: [ rmse_std[a] ],
                                    array: rmse_std, 
                                    //thickness: 0.5,
                                    //width: 1,
                                    //visible: true,
                                },
                                error_y: {
                                    type: 'data',
                                    //array: [ nnz_std[a] ],
                                    array: nnz_std,
                                    //thickness: 0.5,
                                    //width: 5,
                                    //visible: true,
                                },
                                marker: {
                                    sizemode: 'area',
                                    size: 10, 
                                    opacity: 0.8,
                                    //color: 'hsl('+(c[1]*180)+', '+(a*0.1+0.5)+', 0.5)',
                                    //color: 'hsl('+(s*60)+', 0.5, 0.5)',
                                    color: 'rgb('+c[0]*255+', '+c[1]*255+', '+c[2]*255+')',
                                }
                        });
                //}
        }
}

add(hcp3t, 'HCP3T');
add(hcp7t, 'HCP7T');
add(stn96, 'STN96');

var layout = {
        xaxis: {title: "Connectome Error (r.m.s.e.)"},
        yaxis: {title: "Fascicles Number"},
        margin: {t: 20, l: 50, b: 35}, //, l: 30, r:10, b:30},
        background: '#f00',
}      

console.dir({data, layout});

fs.writeFileSync('../plotdata.json', JSON.stringify({data, layout}), 'ascii');

